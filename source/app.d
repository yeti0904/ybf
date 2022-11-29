import std.file;
import std.conv;
import std.stdio;
import std.string;
import core.stdc.stdlib;
import interpreter;

void main(string[] args) {
	string      inputFile = "";
	Interpreter bf = new Interpreter();
	size_t      cellsSize = 30000;
	
	for (size_t i = 1; i < args.length; ++i) {
		if (args[i][0] == '-') {
			switch (args[i]) {
				case "-cs":
				case "--cell-size": {
					++ i;
					if (i == args.length) {
						stderr.writeln("Not given cell size");
						exit(1);
					}
					if (!isNumeric(args[i])) {
						stderr.writeln("Cell size must be numeric");
						exit(1);
					}

					cellsSize = parse!int(args[i]);
					break;
				}
				default: {
					stderr.writefln("Unrecognised parameter: %s", args[i]);
					exit(1);
				}
			}
		}
		else {
			inputFile = args[i];
		}
	}

	bf.InitCells(cellsSize);

	if (inputFile == "") {
		while (true) {
			write("> ");
			stdout.flush();
			bf.Interpret(readln());
		}
	}
	else {
		string program;
		try {
			program = readText(inputFile);
		}
		catch (Throwable e) {
			stderr.writefln("Error reading file: %s", e.msg);
			exit(1);
		}

		bf.Interpret(program);
	}
}
