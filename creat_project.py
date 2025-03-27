import os

# make sure in project folder
os.chdir(r"C:/Users/demea/ModelSim projects") 

# get project name and make a folder
try :
  project_name = input("Enter project name: ")
  project_path = "C:/Users/demea/ModelSim projects/" + project_name
  os.mkdir(project_path)
  os.chdir(project_path)
except FileExistsError:
  print("ERROR FOLDER ALREADY EXISTS")
  project_name = input("Enter a different project name: ")
  project_path = "C:/Users/demea/ModelSim projects/" + project_name
  os.mkdir(project_path)
  os.chdir(project_path)

# make sim and src folders
sim_path = project_path + "/sim"
src_path = project_path + "/src"
os.mkdir(sim_path)
os.mkdir(src_path)

# make top level VHDL file and testbench file
os.chdir(src_path)
top_entity_name = input("What is the name of the top level entity: ")
tb_name = top_entity_name + "_tb.vhd"
top_entity_name = top_entity_name + ".vhd"
top_file = open(top_entity_name,"w")
top_file.close()
os.chdir(sim_path)
tb_file = open(tb_name,"w")
tb_file.close()

# append to gitignore file
os.chdir(r"C:/Users/demea/ModelSim projects") 
gitignore_list = {  "/" + project_name + "/*.cr.mti",
                    "/" + project_name + "/*.mpf",
                    "/" + project_name + "/*.wlf",
                    "/" + project_name + "/work" }

with open(".gitignore", "a") as file:
  file.write("\n")
  for line in gitignore_list:
    file.write(line + "\n")
                                        