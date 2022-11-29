import std.stdio;
import std.algorithm;
import core.stdc.stdlib : exit;

static import core.stdc.stdio;

class Interpreter {
	int[] cells;

	void InitCells(size_t memSize) {
		cells = new int[](memSize);
	}

	void Interpret(string code) {
		size_t   ip      = 0;
		size_t   cellPtr = 0;
		size_t[] loops;
		size_t   col = 0, line = 0;

		for (ip = 0; ip < code.length;) {
			bool increment = true;

			if (code[ip] == '\n') {
				++ line;
				col = 0;
			}
			else {
				++ col;
			}

			switch (code[ip]) {
				case '+': {
					++ cells[cellPtr];
					break;
				}
				case '-': {
					-- cells[cellPtr];
					break;
				}
				case '>': {
					++ cellPtr;
					break;
				}
				case '<': {
					-- cellPtr;
					break;
				}
				case '.': {
					write(cast(char) cells[cellPtr]);
					break;
				}
				case ',': {
					cells[cellPtr] = core.stdc.stdio.getchar();
					break;
				}
				case '[': {
					if (cells[cellPtr] == 0) {
						size_t level = 1;
						++ ip;
						while (level != 0) {
							if (ip >= code.length) {
								stderr.writeln("Unterminated loop");
								exit(1);
							}
							if (code[ip] == '[') {
								++ level;
							}
							else if (code[ip] == ']') {
								-- level;
							}
						}
					}
					else {
						loops ~= ip;
					}
					break;
				}
				case ']': {
					if (loops.length == 0) {
						stderr.writefln(
							"%d:%d: Nowhere to jump back to", line + 1, col + 1
						);
						exit(1);
					}
					if (cells[cellPtr] != 0) {
						ip        = loops[loops.length - 1];
						increment = false;
						loops     = loops.remove(loops.length - 1);
					}
					break;
				}
				default: break;
			}

			ip += increment? 1 : 0;
		}
	}
}
