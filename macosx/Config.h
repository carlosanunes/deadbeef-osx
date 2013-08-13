/*
    DeaDBeeF Cocoa GUI
    Copyright (C) 2012 Carlos Nunes <carloslnunes@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#define PREFIX 1
#define PORTABLE 1
#define VERSION "0.5.6"

/* strdupa does not exist in osx */
#ifndef strdupa
#define strdupa(s) \
	(__extension__ ({const char *__in = (s); \
			 size_t __len = strlen (__in) + 1; \
			 char * __out = (char *) __builtin_alloca (__len); \
			 (char *) memcpy (__out, __in, __len);}))
#endif
