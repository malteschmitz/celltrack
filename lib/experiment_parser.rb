module ExperimentParser
  class << self
    # Does post processing to finish parsing and import of data
    def finishImport(experiment)
      
      # find and set root of each tree
      rootPaths = Path.where('LEFT OUTER JOIN paths_paths ON paths.id = paths_paths.succ_path_id').where('paths_paths.pred_path_id IS NULL')
      rootPaths.each { |r| 
        t = r.tree
        t.root_path = r
        t.save
      }
    end
    
    # Parses a file as adjacency list for the trees in the experiment
    def parseAdjacencyList(experiment, file)
      file.each {
        |line|
        adjacency = line.split(",")
        # find path belonging to adjacency[0] (=> parent)
        parent = Path.find(adjacency[0]).first
        
        # find path belonging to adjacency[1] (=> child)
        child = Path.find(adjacency[1]).first
        
        # check if they have a tree (one may have none or both have the same)
        tree = nil
        if(parent.tree != nil)
          tree = parent.tree
        end
        if(child.tree != nil && tree == nil)
          # if(tree != nil && child.tree != tree) => error
          tree = child.tree
        end
        # if there is no such tree, create one
        if(tree == nil)
          tree = Tree.create(:experiment => experiment)
        end
        
        # update parent and child
        parent.tree = tree
        parent.save
        
        child.tree = tree
        child.save
        
        # REALLY UNSURE 
        # add child to succ_path of parent
        parent.succ_path.push(child)
        
        # add parent to pred_path of child
        child.pred_path.push(parent)
      }
    end
    
    # Parses a file as cellmask of the experiment
    def parseCellmask(experiment, file, filename)
      # create a new image
      image = Image.create(:experiment => experiment, :filename => filename)
    
      # parse each line
      y = 0
      file.each {
        |line|
        
        # increase line counter
        y += 1
        
        # Split line at comma into array
        fields = line.split(",")
        x = 0
        
        # For each element of the line
        fields.each {
          |field|
          x += 1
          if(field != 0)
            # create new coordinates x,y
            coordinate = Coordinate.create(:x => x, :y => y, :image => image, 
                                           :experiment => experiment)
          
            # find a path that belongs to this field
            path = Path.where(:import_id => field)
            if(path.size < 1)
              # create new path
              path = Path.create(:import_id => field, :experiment => experiment)
            else
              # Unpack result array from Path.where statement
              path = path.first
            end
            
            # find cell for the current image and path
            cell = Cell.where(:experiment_id => experiment.id,
                              :image_id => image.id,
                              :path_id => path.id)
            
            # if there is no such cell, create a new one
            if(cell.size < 1)
              cell = Cell.create(:experiment => experiment,
                                 :image => image,
                                 :path => path)
            else
              # unpack result array
              cell = cell.first
            end
            # connect coordinate and cell
            coordinate.cell = cell
          end
        }
      }
    end
    
    # Parse a directory (specified by path) as an experiment
    def parseCellExperiment(experiment, path)
    
      # Find cellmasks directory
      pathToCellmasks = path + "/cellmasks"
      
      # For each cellmask file, call parseCellmask method
      Dir.foreach(pathToCellmasks) { 
        |cellmask| 
        file_path = pathToCellmasks + "/" + cellmask
        puts file_path
        if File.file?(file_path)
          file = File.open(pathToCellmasks + "/" + cellmask, "r")
          parseCellmask(experiment, file, cellmask) 
          file.close
        end
      }
      
      # Find adjacencyList in statusflags
      pathToAdjacencyList = path + "/statusflags/adjacencyList"
      adjacencyListFile = File.open(pathToAdjacencyList, "r")
      parseAdjacencyList(experiment_id, adjacencyListFile)
      adjacencyListFile.close
      
      # run post processing
      finishImport(experiment_id)
    end
    
    def malte
      e = Experiment.create
      ExperimentParser.parseCellExperiment(e, 'db/seeds/refdataA')
    end
  end
end