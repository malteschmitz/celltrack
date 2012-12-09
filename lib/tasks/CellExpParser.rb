
# Does post processing to finish parsing and import of data
def finishImport(experiment_id)
  
  # find roots of trees
  rootPaths = Paths_Path.where(:pred_path => nil)
  rootPaths.each { |r| 
    p = Path.find(r.succ_path)
    t = p.tree
    t.root_path = p
    t.save
  }
end

# Parses a file as adjacency list for the trees in the experiment
def parseAdjacencyList(experiment_id, file)
  file.each {
    |line|
    adjacency = line.split(",")
    
  }
end

# Parses a file as cellmask of the experiment
def parseCellmask(experiment_id, file, filename)
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
        path = Path.where(:import_id => field)
        if(path != nil)
          
        else
          
        end
      end
    }
  }
end

# Parse a directory (specified by path) as an experiment
def parseCellExperiment(experiment_id, path)
  # Find cellmasks directory
  pathToCellmasks = path + "/cellmasks"
  
  # For each cellmask file, call parseCellmask method
  Dir.foreach(pathToCellmasks) { 
    |cellmask| 
    file_path = pathToCellmasks + "/" + cellmask
    puts file_path
    if File.file?(file_path)
      file = File.open(pathToCellmasks + "/" + cellmask, "r")
      parseCellmask(experiment_id, file, cellmask) 
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

=begin
if __FILE__ == $0
  puts "Hello World"
  parseCellExperiment(1, "/home/eike/workspace/celltrack/testData/refdataA")
end=
