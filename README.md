# Magen Helper Submodule Repository

This is a dependency repository that stores all helper scripts for infrastructure that all Magen components depend on.

Instructions:

* **helper_scripts** should be [chmod +x]
* remove entry **lib/** from **.gitignore** of the repo you'd like to add Magen-Helper to

### Add magen-helper submodule to the root of the main repo: 

You can add magen-helper submodule with command:

  ```git submodule add https://github.com/magengit/magen-helper.git lib/magen_helper``` 
  
  This will create folder **/lib/magen_helper** and **.gitmodules** file 
  
  _Note_: you can use ```-b``` flag to add submodule from a specific branch. 
  By default after adding submodule it has up-to-date code under master branch. 
  You may have more then 1 submodule
  
Here is example of ```.gitmodules``` file. You can manually edit it to change settings:

```yaml
[submodule "lib/magen_helper"]
        path = lib/magen_helper
        url = https://github.com/magengit/magen-helper.git
```

### Update submodules

To update dependencies (submodules) to the latest commit you may:

  * do ```git pull``` inside the submodule directory (ex. **lib/magen_helper/**)
  * execute the following command for all submodules: ```git submodule foreach git pull origin {remote_submodule_branch}``` (by default **master** is used)
  * run ```make update``` to automatically update submodules

### Clone repo with submodule

When cloning as usual: ```git clone {path_to_the_repo}``` the **lib/{submodule_name}** will be created automatically but will be left empty until initialized and updated.

When cloning a repo that contains submodule you may:
  
  * do ``git submodule init && git submodule update`` in the submodule directory 
  * clone the whole repo recursively: ``git clone --recursive {path_to_the_repo}``
  * run command ```git submodule update --init --recursive``` Note: Travis will run this command automatically by default, but you have to provide access rights to Travis for the submodule
  * run ```make init``` to automatically initialize submodules
