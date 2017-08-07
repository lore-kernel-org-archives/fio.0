Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/4] man: add proper indentation to "PARAMETER TYPES" section
Date: Mon,  7 Aug 2017 20:37:51 +0300
Message-Id: <20170807173754.80126-2-tkusumi@tuxera.com>
In-Reply-To: <20170807173754.80126-1-tkusumi@tuxera.com>
References: <20170807173754.80126-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit fixes "int" subsection of "PARAMETER TYPES" section
which had no indentation, while other sections normally do have
proper indentation.

The corresponding section in HOWTO also has indentation.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 108 +++++++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 77 insertions(+), 31 deletions(-)

diff --git a/fio.1 b/fio.1
index a5ec199..2919686 100644
--- a/fio.1
+++ b/fio.1
@@ -223,84 +223,130 @@ hours, 'm' for minutes, 's' for seconds, 'ms' (or 'msec') for milliseconds and '
 .I int
 Integer. A whole number value, which may contain an integer prefix
 and an integer suffix.
-
+.RS
+.RS
+.P
 [*integer prefix*] **number** [*integer suffix*]
-
+.RE
+.P
 The optional *integer prefix* specifies the number's base. The default
 is decimal. *0x* specifies hexadecimal.
-
+.P
 The optional *integer suffix* specifies the number's units, and includes an
 optional unit prefix and an optional unit. For quantities of data, the
 default unit is bytes. For quantities of time, the default unit is seconds
 unless otherwise specified.
-
-With \fBkb_base=1000\fR, fio follows international standards for unit
+.P
+With `kb_base=1000', fio follows international standards for unit
 prefixes. To specify power-of-10 decimal values defined in the
 International System of Units (SI):
-
-.nf
+.RS
+.P
 ki means kilo (K) or 1000
+.RE
+.RS
 mi means mega (M) or 1000**2
+.RE
+.RS
 gi means giga (G) or 1000**3
+.RE
+.RS
 ti means tera (T) or 1000**4
+.RE
+.RS
 pi means peta (P) or 1000**5
-.fi
-
+.RE
+.P
 To specify power-of-2 binary values defined in IEC 80000-13:
-
-.nf
+.RS
+.P
 k means kibi (Ki) or 1024
+.RE
+.RS
 m means mebi (Mi) or 1024**2
+.RE
+.RS
 g means gibi (Gi) or 1024**3
+.RE
+.RS
 t means tebi (Ti) or 1024**4
+.RE
+.RS
 p means pebi (Pi) or 1024**5
-.fi
-
-With \fBkb_base=1024\fR (the default), the unit prefixes are opposite
+.RE
+.P
+With `kb_base=1024' (the default), the unit prefixes are opposite
 from those specified in the SI and IEC 80000-13 standards to provide
 compatibility with old scripts. For example, 4k means 4096.
-
+.P
 For quantities of data, an optional unit of 'B' may be included
 (e.g., 'kB' is the same as 'k').
-
+.P
 The *integer suffix* is not case sensitive (e.g., m/mi mean mebi/mega,
 not milli). 'b' and 'B' both mean byte, not bit.
-
-Examples with \fBkb_base=1000\fR:
-
-.nf
+.P
+Examples with `kb_base=1000':
+.RS
+.P
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
+.RE
+.RS
 1 MiB: 1048576, 1m, 1024k
+.RE
+.RS
 1 MB: 1000000, 1mi, 1000ki
+.RE
+.RS
 1 TiB: 1073741824, 1t, 1024m, 1048576k
+.RE
+.RS
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
-.fi
-
-Examples with \fBkb_base=1024\fR (default):
-
-.nf
+.RE
+.P
+Examples with `kb_base=1024' (default):
+.RS
+.P
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
+.RE
+.RS
 1 MiB: 1048576, 1m, 1024k
+.RE
+.RS
 1 MB: 1000000, 1mi, 1000ki
+.RE
+.RS
 1 TiB: 1073741824, 1t, 1024m, 1048576k
+.RE
+.RS
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
-.fi
-
+.RE
+.P
 To specify times (units are not case sensitive):
-
-.nf
+.RS
+.P
 D means days
+.RE
+.RS
 H means hours
+.RE
+.RS
 M mean minutes
+.RE
+.RS
 s or sec means seconds (default)
+.RE
+.RS
 ms or msec means milliseconds
+.RE
+.RS
 us or usec means microseconds
-.fi
-
+.RE
+.P
 If the option accepts an upper and lower range, use a colon ':' or
 minus '-' to separate such values. See `irange` parameter type.
 If the lower value specified happens to be larger than the upper value
 the two values are swapped.
+.RE
 .TP
 .I bool
 Boolean. Usually parsed as an integer, however only defined for
-- 
2.9.4


