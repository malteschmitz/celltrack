class ExperimentParser
  # Parse a directory (specified by path) as an experiment
  def initialize(experiment, path)
    @experiment = experiment
    
    # Find cellmasks directory
    pathToCellmasks = path + "/cellmasks"
    
    # maps import field numbers to database path ids
    @paths = Hash.new
    @path_id = Path.maximum(:id) || 0
    
    @cell_id = Cell.maximum(:id) || 0
    
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
    
    # Find adjacencyList in statusflags
    #pathToAdjacencyList = path + "/statusflags/adjacencyList"
    #adjacencyListFile = File.open(pathToAdjacencyList, "r")
    #parseAdjacencyList(experiment, adjacencyListFile)
    #adjacencyListFile.close
    
    # run post processing
    #findRootPaths(experiment)
  end
    
  # Parses a file as cellmask of the experiment
  def parseCellmask(file, image_filename)
    # create a new image
    image = Image.create!(:experiment => @experiment, :filename => image_filename)
    
    # maps import filed numbers to database cell ids
    cells = Hash.new
    
    # maps cell id to bounding box coordinates
    minX = Hash.new
    minY = Hash.new
    maxX = Hash.new
    maxY = Hash.new
    
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
    
    cell_array = []
    cells.each do |field, cell|
      bv = BitVector.new
      minY[cell].upto(maxX[cell]) do |x|
        minY[cell].upto(maxY[cell]) do |y|
          if data[y][x] == field
            bv << 1
          else
            bv << 0
          end
        end
      end
      cell_array << [cell, @experiment.id, image.id, @paths[field], bv.to_binary]
    end
    Cell.import [:id, :experiment_id, :image_id, :path_id, :mask], cell_array
  end
    
  # Parses a file as adjacency list for the trees in the experiment
  def parseAdjacencyList(file)
    file.each do |line|
      adjacency = line.split(",")
      # find path belonging to adjacency[0] (=> parent)
      parent = Path.find_by_import_id(adjacency[0])
      
      # find path belonging to adjacency[1] (=> child)
      child = Path.find_by_import_id(adjacency[1])
      
      # check if they have a tree (one may have none or both have the same)
      tree = nil
      if !parent.tree.nil?
        tree = parent.tree
      end
      if !child.tree.nil? && tree.nil?
        tree = child.tree
      end
      # if there is no such tree, create one
      if tree.nil?
        tree = Tree.create!(:experiment => experiment)
      end
      
      # update parent and child
      parent.tree = tree
      child.tree = tree
       
      # add child to succ_path of parent (and vice versa)
      parent.succ_paths << child
      
      parent.save!
      child.save!
    end
  end
    
  # Finds the root of each tree and sets the root_path property of the tree
  def findRootPaths
    # find and set root of each tree
    rootPaths = Path.joins('LEFT OUTER JOIN paths_paths ON paths.id = paths_paths.succ_path_id').where('paths_paths.pred_path_id IS NULL').select('paths.*')
    rootPaths.each do |r| 
      if !r.tree.nil?
        t = r.tree
      else
        t = Tree.create!(:experiment => experiment)
        r.tree = t
        r.save!
      end
      
      t.root_path = r
      t.save!
    end
  end
  
  def self.parseCellExperiment(experiment, path)
    ExperimentParser.new(experiment, path)
  end
  
  def self.malte
    e = Experiment.create!
    ExperimentParser.parseCellExperiment(e, 'db/seeds/malte')
  end
end
