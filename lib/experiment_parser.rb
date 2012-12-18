class ExperimentParser
  # private helper class to import data into paths_paths join table
  class PathsPaths < ActiveRecord::Base
    # nothing in here
  end

  # Parse a directory (specified by path) as an experiment
  def initialize(experiment, path)
    @experiment = experiment
    
    # Find cellmasks directory
    pathToCellmasks = path + "/cellmasks"
    
    # maps import path numbers to database path ids
    @paths = {}
    # next free id in paths table
    @path_id = Path.maximum(:id) || 0
    # next free id in cells table
    @cell_id = Cell.maximum(:id) || 0
    # list of images
    @images = []
    @image_id = Image.maximum(:id) || 0
    # next free id in 
    @tree_id = Tree.maximum(:id) || 0
    # list of trees
    @trees = []
    
    # For each cellmask file, call parseCellmask method
    files = Dir.entries(pathToCellmasks)
    files = files.sort
    files.each do |filename| 
      file_path = pathToCellmasks + "/" + filename
      if File.file?(file_path)
        puts file_path
        file = File.open(pathToCellmasks + "/" + filename, "r")
        parseCellmask(file, filename)
        file.close
      end
    end
    
    # compute information of images
    image_array = []
    @images.each do |id, file_name|
      image_array << [id, experiment.id, file_name]
    end
    # import images into databse
    Image.import [:id, :experiment_id, :filename], image_array,
      :validate => false
    
    # Find adjacencyList in statusflags and import paths
    pathToAdjacencyList = path + "/statusflags/adjacencyList"
    adjacencyListFile = File.open(pathToAdjacencyList, "r")
    parseAdjacencyList(adjacencyListFile)
    adjacencyListFile.close
    
    # run post processing and import trees
    findRootPaths
  end
    
  # Parses a file as cellmask of the experiment
  def parseCellmask(file, image_filename)
    # create a new image
    @images << [image_id = @image_id += 1, image_filename]
    
    # maps import filed numbers to database cell ids
    cells = {}
    
    # maps cell id to bounding box coordinates
    minX = {}
    minY = {}
    maxX = {}
    maxY = {}
    
    # import data from file to variable data
    data = []
    file.each do |line|
      data << line.split(',').map(&:to_i)
    end
    
    # set current row and column count
    rows = data.length
    cols = data.first.length
    
    # parse each element of data
    0.upto(rows-1) do |y|
      0.upto(cols-1) do |x|
        field = data[y][x]
        if field > 0
          # is there a path to this field value?
          if @paths[field].nil?
            @paths[field] = @path_id += 1
          end
          
          # is there already a cell for this field value?
          cell = cells[field]
          if cell.nil?
            cell = cells[field] = @cell_id += 1
            minX[cell] = maxX[cell] = x
            minY[cell] = maxY[cell] = y
          else
            # this cell (representation of a path) has already been found
            # update bounding box values if necessary
            minX[cell] = x if x < minX[cell]
            maxX[cell] = x if x > maxX[cell]
            minY[cell] = y if y < minY[cell]
            maxY[cell] = y if y > maxY[cell]
          end
        end
      end
    end
  
    # compute information of cells  
    cell_array = []
    cells.each do |field, cell|
      bv = BitVector.new
      centerX = 0
      centerY = 0
      count = 0
      minX[cell].upto(maxX[cell]) do |x|
        minY[cell].upto(maxY[cell]) do |y|
          if data[y][x] == field
            bv << 1
            centerX += x
            centerY += y
            count += 1
          else
            bv << 0
          end
        end
      end
      width = maxX[cell] - minX[cell] + 1
      height = maxY[cell] - minY[cell] + 1
      centerX /= count
      centerY /= count
      cell_array << [cell, @experiment.id, image_id, @paths[field],
        bv.to_binary, minY[cell], minX[cell], width, height,
        centerX, centerY]
    end
    # import cells into database
    Cell.import [:id, :experiment_id, :image_id, :path_id, :mask, :top, :left,
      :width, :height, :center_x, :center_y], cell_array, :validate => false
  end
    
  # Parses a file as adjacency list for the trees in the experiment
  def parseAdjacencyList(file)
    # list of adjacencies contains pairs of database path ids
    adjacencies = []
    # maps database path ids to database tree ids of its tree
    tree_of_path = {}
  
    file.each do |line|
      adjacency = line.split(",").map(&:to_i)
      # find path belonging to adjacency[0] (=> parent)
      parent = @paths[adjacency[0]]
      
      # find path belonging to adjacency[1] (=> child)
      child = @paths[adjacency[1]]
      
      # check if they have a tree (one may have none or both have the same)
      tree = tree_of_path[parent] || tree_of_path[child]
      if tree.nil?
        @trees << tree = @tree_id += 1
      end
      
      # update parent and child
      tree_of_path[parent] = tree
      tree_of_path[child] = tree
       
      # add child to succ_path of parent (and vice versa)
      adjacencies << [parent, child]
    end
    
    # compute information of paths
    path_array = []
    @paths.each_value do |id|
      # handle paths which did not occur in adjacency list
      tree = tree_of_path[id]
      @trees << tree = @tree_id += 1 if tree.nil?
      path_array << [id, @experiment.id, tree]
    end
    # import paths into databse
    Path.import [:id, :experiment_id, :tree_id], path_array, :validate => false
    
    # import paths_paths into database
    # TODO do not try to create id, created_at and updated_at
    PathsPaths.import [:pred_path_id, :succ_path_id], adjacencies
  end
    
  # Finds the root of each tree and sets the root_path property of the tree
  def findRootPaths
    # maps database tree ids to database path ids of its root paths
    roots = {}
    
    # find and set root of each tree
    rootPaths = Path.joins('LEFT OUTER JOIN paths_paths ON paths.id = paths_paths.succ_path_id').where('paths_paths.pred_path_id IS NULL').select('paths.*')
    rootPaths.each do |r| 
      roots[r.tree_id] = r
    end
    
    # compute information of trees
    tree_array = []
    @trees.each do |id|
      tree_array << [id, @experiment.id, roots[id]]
    end
    # import trees into databse
    Tree.import [:id, :experiment_id, :root_path_id], tree_array,
      :validate => false
  end
  
  def self.parseCellExperiment(experiment, path)
    ExperimentParser.new(experiment, path)
  end
  
  def self.malte
    e = Experiment.create!
    ExperimentParser.parseCellExperiment(e, 'db/seeds/malte')
  end
end
