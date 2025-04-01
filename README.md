# BashConf

This repository contains text format parsers written in Bash which are
particularly useful for configurations, for example in build scripts.

## INI

The INI parser has the following usage pattern:

```bash
./ini.sh <action> [action-arg] <input-file>
```

> All actions except `--help` support  the argument `-o <path>` or the
> alternative `--output <path>` which tells where to write the result.
> If the no output path is given, `stdout` is used.

### `-l` or `--list-sections`  

List all sections in the file, one item per line. This action does not
need any  specialized arguments.  

```bash
./ini.sh --list-sections configuration.ini -o sections.txt
```

### `-f` or `--list-fields`  

List all fields within a section. This action requires the name of the
section of which to get the fields.  

```bash
./ini.sh --list-fields Arguments configuration.ini -o fields.txt
```

### `-g`, `--get` or `--get-value`  

Returns the value  identified right after the action  in the format of
`<section>:<key>`. An example for it is:

```bash
./ini.sh --get-value General:Name configuration.ini -o name.txt
```

