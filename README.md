<h1 align="center">Todo.sh</h1>
<h3 align="center">Simple Todo Management CUI Application</h3>

<p align="center">
 <a href="https://travis-ci.com/utam0k/todo.sh">
   <img src="https://travis-ci.com/utam0k/todo.sh.svg?token=oEU9eveDCuSJtEKxsBNy&branch=master" alt="Build Status">
 </a>
 <a href="LICENSE">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT">
 </a>
</p>

# Install
Execute following command as the *root* user.
```
$ make install 
```

# Usage
```
$ todo.sh ${subcommand} ${options}
```

# Subcommands
## new
Create today's todo file.
```
$ todo.sh new
```

## ls
Show today's todos that haven't ended.
```
$ todo.sh ls ${options}
```

### Options
-p  Show todo for each project.  
-a  Show all todos.

## open
Open today's todos.
```
$ todo.sh open
```


# Todo Text Example
```
- (C) 2019-10-03 todo todoの改良
```
