// Enable VT100 support for console and work as a pipe:
// copy data from standard input into standard output.
#include "stdafx.h"

#ifndef ENABLE_VIRTUAL_TERMINAL_PROCESSING
#define ENABLE_VIRTUAL_TERMINAL_PROCESSING 0x0004
#endif

int _tmain(int argc, _TCHAR* argv[])
{
	TCHAR *buffer = new TCHAR[2048];	// will never release this buffer, sorry :)

	HANDLE console = GetStdHandle(STD_OUTPUT_HANDLE);
	if (console == INVALID_HANDLE_VALUE)
		return GetLastError();;

	DWORD dwMode = 0;
	if (!GetConsoleMode(console, &dwMode))
		return GetLastError();

	dwMode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
	if (!SetConsoleMode(console, dwMode))
		return GetLastError();

	HANDLE input = GetStdHandle(STD_INPUT_HANDLE);
	if (console == INVALID_HANDLE_VALUE)
		return GetLastError();

	while (true) {
		DWORD readBytes = 0;
		if (!ReadFile(input, buffer, 2048, &readBytes, NULL))
			return GetLastError();

		DWORD writtenBytes = 0;
		if (!WriteFile(console, buffer, readBytes, &writtenBytes, NULL))
			return GetLastError();
	}

	return 0;
}
