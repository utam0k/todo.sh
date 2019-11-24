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

# Overview 
TBD

# Features
- simple
- bash
- plugin

# TODO format
Space separated.
```
[-|x] YYYY-MM-DD Project+Subproject Description
```
- 1 row: whether this todo is over(`-`: yet, `x`: finished).
- 2 row: start date.
- 3 row: project of this todo. Subprojects if necessary.
- 4 row: description of this todo.

e.g.
```
- (C) 2019-10-03 todo improve
- (C) 2019-10-03 todo+usability README
```


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

If you want to see past todos, enter the following command.  
The number of `^` determine how many will go back in the past.
```
$ todo.sh ls ^^
```

### Options
-p  Show todo for each project.  
-a  Show all todos.

## open
Open today's todos and you can edit it.
```
$ todo.sh open
```


# Todo Text Example
```
- (C) 2019-10-03 todo improve
```
