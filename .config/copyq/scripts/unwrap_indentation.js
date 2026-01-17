// efficiency is important since this runs for every copy

const MAX_INDENTATION_DEPTH = 100

// input() is always string
const text = str(input())
let lines = text.split('\n')

// Filter non-empty lines once - they will always remain non-empty
const nonEmptyLines = lines.filter((line) => line.length > 0)
const nonEmptyCount = nonEmptyLines.length

if (nonEmptyCount === 0) {
	copy('')
	exit()
}

const processIndentation = (char) => {
	const hasIndentation = nonEmptyLines.every((line) => line.startsWith(char))

	if (!hasIndentation) return false

	for (let i = 0; i < lines.length; i++) {
		if (lines[i].startsWith(char)) {
			lines[i] = lines[i].slice(1).replace(/\s+$/, '')
		}
	}
	return true
}

// Process one level of indentation per iteration
for (let iteration = 0; iteration < MAX_INDENTATION_DEPTH; iteration++) {
	if (processIndentation('\t')) continue
	if (processIndentation(' ')) continue

	// If neither condition is met, we are finished
	break
}

const result = lines //
	.join('\n')
	.replace(/^(\t+)/gm, (match) => match.replace(/\t/g, '  '))

copy(result)
