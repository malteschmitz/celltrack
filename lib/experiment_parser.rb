module ExperimentParser
  class << self
    
    @data = []
    @rows = 0
    @cols = 0
    
    # hash map of paths (unique for a complete experiment)
    @paths = Hash.new
    
    # hash map for each bound box attribute
    @minX = Hash.new
    @minY = Hash.new
    @maxX = Hash.new
    @maxY = Hash.new
    
    # Returns true if the field (c,x,y) is on the border of a cell, 
    # false otherwise. c: field value, x,y: coordinates of field
    def border?(c, x, y)
      x == 0 ||
      x == @cols - 1 ||
      y == 0 ||
      y == @rows - 1 ||
      @data[y][x-1] != c ||
      @data[y-1][x] != c ||
      @data[y][x+1] != c ||
      @data[y+1][x] != c
    end
    
    # Finds the root of each tree and sets the root_path property of the tree
    def findRootPaths(experiment)
      
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
    
    # Parses a file as adjacency list for the trees in the experiment
    def parseAdjacencyList(experiment, file)
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
    
    # Parses a file as cellmask of the experiment
    def parseCellmask(experiment, file, filename)
      # Columns for activerecord-import on Coordinate
      coordinate_cols = [ :cell_id, :image_id, :experiment_id, :x, :y ]
    
      # create a new image
      image = Image.create!(:experiment => experiment, :filename => filename)
      
      # coordinates array
      coordinates = []
      
      # cells hashmap
      cells = Hash.new
      
      # bounding box hashmap
      @minX = Hash.new
      @minY = Hash.new
      @maxX = Hash.new
      @maxY = Hash.new
      
      # import data from file to variable data
      @data = []
      file.each do |line|
        @data << line.split(',').map(&:to_i)
      end
      
      # set current row and column count
      @rows = @data.length
      @cols = @data.first.length
      
      # parse each element of data
      0.upto(@rows-1) do |y|
        0.upto(@cols-1) do |x|
          field = @data[y][x]
          if field > 0
            if border?(field, x, y)
              
              # is there a path to this field value?
              path = @paths[field]
              if path.nil?
                # no in-memory path found, check database
                path = Path.where(:import_id => field)
                
                if path.empty?
                  # no database entry found, create one
                  # necessary because connecting to other models not possible
                  # without id. (new does not result in an id)
                  path = Path.create!(:import_id => field)
                else
                  path = path.first
                end
                
                # add path to hashmap
                @paths[field] = path
              end
              
              # is there already a cell model for this image and field value?
              cell = cells[field]
              if cell.nil?
                # no in-memory cell found, create one
                # necessary because connecting to other models not possible
                # without id. (new does not result in an id)
                cell = Cell.create!(:experiment => experiment, :image => image,
                                :path => path)
                # add to hashmap
                cells[field] = cell
                
                # initialize bounding box values
                @minX[field] = x
                @maxX[field] = x + 1
                @minY[field] = y
                @maxY[field] = y + 1
              else
                # this cell (representation of a path) has already been found
                # update bounding box values if necessary
                @minX[field] = x if x < @minX[field]
                @maxX[field] = x + 1 if x >= @maxX[field]
                @minY[field] = y if y < @minY[field]
                @maxY[field] = y + 1 if y >= @maxY[field]
              end
              
              # create new coordinate (because field is element of border)
              coordinate = [ cell.id, image.id, experiment.id, x, y ]
              
              # push coordinate on coordinates array
              coordinates << coordinate
            end
          end
        end
      end  
      
=begin #debug output      
      cells.each do |cell, value|
        puts "#{cell}: #{@minX[cell]} #{@maxX[cell]} #{@minY[cell]} #{@maxY[cell]}"
      end
=end
      
      # All fields were parsed, use activerecord-import for faster database
      # write
      # Not the fastest method. Use columns directly for fastest import
      Coordinate.import coordinate_cols, coordinates, :validate => false
    end
    
    # Parse a directory (specified by path) as an experiment
    def parseCellExperiment(experiment, path)
    
      # Find cellmasks directory
      pathToCellmasks = path + "/cellmasks"
      
      @paths = Hash.new
      
      # For each cellmask file, call parseCellmask method
      files = Dir.entries(pathToCellmasks)
      files = files.sort
      files.each do |cellmask| 
        file_path = pathToCellmasks + "/" + cellmask
        if File.file?(file_path)
          puts file_path
          file = File.open(pathToCellmasks + "/" + cellmask, "r")
          parseCellmask(experiment, file, cellmask) 
          file.close
        end
      end
      
      # Find adjacencyList in statusflags
      pathToAdjacencyList = path + "/statusflags/adjacencyList"
      adjacencyListFile = File.open(pathToAdjacencyList, "r")
      parseAdjacencyList(experiment, adjacencyListFile)
      adjacencyListFile.close
      
      # run post processing
      findRootPaths(experiment)
    end
    
    def malte
      e = Experiment.create!
      ExperimentParser.parseCellExperiment(e, 'db/seeds/malte')
    end
  end
end
