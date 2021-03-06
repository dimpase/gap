/****************************************************************************
**
**  This file is part of GAP, a system for computational discrete algebra.
**
**  Copyright of GAP belongs to its developers, whose names are too numerous
**  to list here. Please refer to the COPYRIGHT file for details.
**
**  SPDX-License-Identifier: GPL-2.0-or-later
*/

#ifndef GAP_SYSENV_H
#define GAP_SYSENV_H

#ifdef SYS_IS_CYGWIN32

// cygwin declares environ in unistd.h
#include <unistd.h>

#elif defined(__APPLE__)

#include <crt_externs.h>
#define environ (*_NSGetEnviron())

#elif !defined(environ)

extern char ** environ;

#endif

#endif    // GAP_SYSENV_H
