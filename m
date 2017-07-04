Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/7] man: sync "PARAMETER TYPES" section with HOWTO
Date: Tue,  4 Jul 2017 21:08:13 +0300
Message-Id: <20170704180816.39585-5-tkusumi@tuxera.com>
In-Reply-To: <20170704180816.39585-1-tkusumi@tuxera.com>
References: <20170704180816.39585-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit brings in updates from HOWTO to man page. As a result it
replaces some entire paragraphs with the corresponding ones in HOWTO,
though not much difference for the replaced part as it only had small
modification basically saying the same thing.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 74 ++++++++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/fio.1 b/fio.1
index 629ab01..1fd928f 100644
--- a/fio.1
+++ b/fio.1
@@ -212,25 +212,32 @@ parentheses).
 The following parameter types are used.
 .TP
 .I str
-String: a sequence of alphanumeric characters.
+String. A sequence of alphanumeric characters.
+.TP
+.I time
+Integer with possible time suffix. Without a unit value is interpreted as
+seconds unless otherwise specified. Accepts a suffix of 'd' for days, 'h' for
+hours, 'm' for minutes, 's' for seconds, 'ms' (or 'msec') for milliseconds and 'us'
+(or 'usec') for microseconds. For example, use 10m for 10 minutes.
 .TP
 .I int
 Integer. A whole number value, which may contain an integer prefix
 and an integer suffix.
 
-[integer prefix]number[integer suffix]
+[*integer prefix*] **number** [*integer suffix*]
+
+The optional *integer prefix* specifies the number's base. The default
+is decimal. *0x* specifies hexadecimal.
 
-The optional integer prefix specifies the number's base. The default
-is decimal. 0x specifies hexadecimal.
+The optional *integer suffix* specifies the number's units, and includes an
+optional unit prefix and an optional unit. For quantities of data, the
+default unit is bytes. For quantities of time, the default unit is seconds
+unless otherwise specified.
 
-The optional integer suffix specifies the number's units, and includes
-an optional unit prefix and an optional unit.  For quantities
-of data, the default unit is bytes. For quantities of time,
-the default unit is seconds.
+With \fBkb_base=1000\fR, fio follows international standards for unit
+prefixes. To specify power-of-10 decimal values defined in the
+International System of Units (SI):
 
-With \fBkb_base=1000\fR, fio follows international standards for unit prefixes.
-To specify power-of-10 decimal values defined in the International
-System of Units (SI):
 .nf
 ki means kilo (K) or 1000
 mi means mega (M) or 1000**2
@@ -240,6 +247,7 @@ pi means peta (P) or 1000**5
 .fi
 
 To specify power-of-2 binary values defined in IEC 80000-13:
+
 .nf
 k means kibi (Ki) or 1024
 m means mebi (Mi) or 1024**2
@@ -248,12 +256,19 @@ t means tebi (Ti) or 1024**4
 p means pebi (Pi) or 1024**5
 .fi
 
-With \fBkb_base=1024\fR (the default), the unit prefixes are opposite from
-those specified in the SI and IEC 80000-13 standards to provide
-compatibility with old scripts.  For example, 4k means 4096.
+With \fBkb_base=1024\fR (the default), the unit prefixes are opposite
+from those specified in the SI and IEC 80000-13 standards to provide
+compatibility with old scripts. For example, 4k means 4096.
+
+For quantities of data, an optional unit of 'B' may be included
+(e.g., 'kB' is the same as 'k').
+
+The *integer suffix* is not case sensitive (e.g., m/mi mean mebi/mega,
+not milli). 'b' and 'B' both mean byte, not bit.
 
-.nf
 Examples with \fBkb_base=1000\fR:
+
+.nf
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
 1 MiB: 1048576, 1m, 1024k
 1 MB: 1000000, 1mi, 1000ki
@@ -261,8 +276,9 @@ Examples with \fBkb_base=1000\fR:
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
 .fi
 
-.nf
 Examples with \fBkb_base=1024\fR (default):
+
+.nf
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
 1 MiB: 1048576, 1m, 1024k
 1 MB: 1000000, 1mi, 1000ki
@@ -270,13 +286,8 @@ Examples with \fBkb_base=1024\fR (default):
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
 .fi
 
-For quantities of data, an optional unit of 'B' may be included
-(e.g.,  'kb' is the same as 'k').
-
-The integer suffix is not case sensitive (e.g., m/mi mean mebi/mega,
-not milli). 'b' and 'B' both mean byte, not bit.
-
 To specify times (units are not case sensitive):
+
 .nf
 D means days
 H means hours
@@ -286,20 +297,23 @@ ms or msec means milliseconds
 us or usec means microseconds
 .fi
 
+If the option accepts an upper and lower range, use a colon ':' or
+minus '-' to separate such values. See `irange` parameter type.
+If the lower value specified happens to be larger than the upper value
+the two values are swapped.
 .TP
 .I bool
-Boolean: a true or false value. `0' denotes false, `1' denotes true.
+Boolean. Usually parsed as an integer, however only defined for
+true and false (1 and 0).
 .TP
 .I irange
-Integer range: a range of integers specified in the format
-\fIlower\fR:\fIupper\fR or \fIlower\fR\-\fIupper\fR. \fIlower\fR and
-\fIupper\fR may contain a suffix as described above.  If an option allows two
-sets of ranges, they are separated with a `,' or `/' character. For example:
-`8\-8k/8M\-4G'.
+Integer range with suffix. Allows value range to be given, such as
+1024-4096. A colon may also be used as the separator, e.g. 1k:4k. If the
+option allows two sets of ranges, they can be specified with a ',' or '/'
+delimiter: 1k-4k/8k-32k. Also see `int` parameter type.
 .TP
 .I float_list
-List of floating numbers: A list of floating numbers, separated by
-a ':' character.
+A list of floating point numbers, separated by a ':' character.
 .SH "JOB DESCRIPTION"
 With the above in mind, here follows the complete list of fio job parameters.
 .TP
-- 
2.9.4


