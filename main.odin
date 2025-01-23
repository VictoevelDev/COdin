
package main
import "core:fmt"
import "core:strings"
import "core:c"
import "core:mem"
import "core:os"
import "core:io"
import "core:sys/windows"
import "base:runtime"

poolsize :: 256 * 1024

token: byte
line, cycle: int

pc, bp, sp, ax : ^int

src: ^[poolsize]byte
srcIndex: int

oldSrc: ^[poolsize]byte
oldSrcIndex: int

text, oldText, stack: ^[poolsize]int
textIndex, oldTextIndex, stackIndex : int

data: ^[poolsize]byte
dataIndex : int

INS :: enum {
	LEA,
	IMM,
	JMP,
	CALL,
	JZ,
	JNZ,
	ENT,
	ADJ,
	LEV,
	LI,
	LC,
	SI,
	SC,
	PUSH,
	OR,
	XOR,
	AND,
	EQ,
	NE,
	LT,
	GT,
	LE,
	GE,
	SHL,
	SHR,
	ADD,
	SUB,
	MUL,
	DIV,
	MOD,
	OPEN,
	READ,
	CLOS,
	PRTF,
	MALC,
	MSET,
	MCMP,
	EXIT,
}

main :: proc() {
	argv := os.args
	argvIndex := 1
	argc := len(argv) - 1
	line = 1

	fmt.printf("argv[%d]: %s\n", argvIndex, argv[argvIndex])
	fd, errOpen := os.open(argv[argvIndex], os.O_RDONLY)
	defer os.close(fd)

	if errOpen != nil{
		fmt.printf("Error abriendo archivo\n")
		return
	}

	src = new([poolsize]byte)
	defer free(src)
	oldSrc = src
	i, errRead := os.read(fd, src[0:])
	if i <= 0 || errRead != nil{
		fmt.printf("Error leyendo archivo\n")
	}
	src[i] = 0

	text = new([poolsize]int)
	defer free(text)
	oldText = text
	
	data = new([poolsize]byte)
	defer free(data)
	
	stack = new([poolsize]int)
	defer free(stack)

	runtime.memset(text, 0, poolsize)
	runtime.memset(data, 0, poolsize)
	runtime.memset(stack, 0, poolsize)

	bp = (^int)(uintptr(stack) + poolsize)
	sp = bp


	program()
	eval()
}

next :: proc() {
	srcIndex += 1
	token = (src[srcIndex])
}

expresssion :: proc(level: int) {
	
}

program :: proc() {
	next()
	for token > 0 {
		fmt.printf("token is: %c\n", token) 
		next()
	}
}

eval :: proc() -> int{
	return 0
}