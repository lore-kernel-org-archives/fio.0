Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44791 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaBKAmX convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 10 Feb 2014 19:42:23 -0500
Received: from G9W0364.americas.hpqcorp.net (g9w0364.houston.hp.com [16.216.193.45])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t0016.houston.hp.com (Postfix) with ESMTPS id A28911400B
	for <fio@vger.kernel.org>; Tue, 11 Feb 2014 00:42:22 +0000 (UTC)
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: [PATCH] Fix documentation of SI vs. binary prefixes
Date: Tue, 11 Feb 2014 00:40:56 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548A6481@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

fio specifies SI and binary units backwards, presumably for compatibility with old scripts.  The description in HOWTO and the man page should acknowledge this.  I suggest fixing it something like this.

diff --git a/HOWTO b/HOWTO
index 9830fa1..55abbe0 100644
--- a/HOWTO
+++ b/HOWTO
@@ -224,20 +224,49 @@ str	String. This is a sequence of alpha characters.
 time	Integer with possible time suffix. In seconds unless otherwise
 	specified, use eg 10m for 10 minutes. Accepts s/m/h for seconds,
 	minutes, and hours.
-int	SI integer. A whole number value, which may contain a suffix
-	describing the base of the number. Accepted suffixes are k/m/g/t/p,
-	meaning kilo, mega, giga, tera, and peta. The suffix is not case
-	sensitive, and you may also include trailing 'b' (eg 'kb' is the same
-	as 'k'). So if you want to specify 4096, you could either write
-	out '4096' or just give 4k. The suffixes signify base 2 values, so
-	1024 is 1k and 1024k is 1m and so on, unless the suffix is explicitly
-	set to a base 10 value using 'kib', 'mib', 'gib', etc. If that is the
-	case, then 1000 is used as the multiplier. This can be handy for
-	disks, since manufacturers generally use base 10 values when listing
-	the capacity of a drive. If the option accepts an upper and lower
-	range, use a colon ':' or minus '-' to separate such values.  May also
-	include a prefix to indicate numbers base. If 0x is used, the number
-	is assumed to be hexadecimal.  See irange.
+int	Integer. A whole number value, which may contain an integer prefix
+	and an integer suffix. 
+	[integer prefix]number[integer suffix]
+
+	The optional integer prefix specifies the number's base. The default 
+	is decimal. 0x specifies hexadecimal.
+
+	The optional integer suffix specifies the number's units, and includes
+	a unit prefix and an optional unit.  The default unit is bytes.
+
+	NOTE: For compatibility with old scripts, the unit prefixes are 
+	opposite from those specified in the SI and IEC 80000-13 standards.
+                
+	To specify base2 binary values defined in IEC 80000-13:
+		k means kibi (Ki) or 1024
+		m means mebi (Mi) or 1024**2
+		g means gibi (Gi) or 1024**3
+		t means tebi (Ti) or 1024**4
+		p means pebi (Pi) or 1024**5
+
+	To specify base10 decimal values defined in the International
+	System of Units (SI):
+		ki means kilo (K) or 1000
+		mi means mega (M) or 1000**2
+		gi means giga (G) or 1000**3
+		ti means tera (T) or 1000**4
+		pi means peta (P) or 1000**5
+
+	An optional unit of 'b' may be included (e.g.,  'kb' is the same 
+	as 'k'). 
+
+	The integer suffix is not case sensitive (e.g., m/mi mean mebi/mega, 
+	not milli). 'b' and 'B' both mean byte, not bit.
+
+	Examples:
+		4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
+		1 MiB: 1048576, 1m, 1024k 
+		1 MB: 1000000, 1mi, 1000ki
+		1 TiB: 1073741824, 1t, 1024m, 1048576k
+		1 TB: 1000000000, 1ti, 1000mi, 1000000ki
+
+	If the option accepts an upper and lower range, use a colon ':' or 
+	minus '-' to separate such values.   See irange.
 bool	Boolean. Usually parsed as an integer, however only defined for
 	true and false (1 and 0).
 irange	Integer range with suffix. Allows value range to be given, such
diff --git a/fio.1 b/fio.1
index ec10377..afeb89f 100644
--- a/fio.1
+++ b/fio.1
@@ -118,15 +118,63 @@ Some parameters may take arguments of a specific type.  The types used are:
 String: a sequence of alphanumeric characters.
 .TP
 .I int
-SI integer: a whole number, possibly containing a suffix denoting the base unit
-of the value.  Accepted suffixes are `k', 'M', 'G', 'T', and 'P', denoting
-kilo (1024), mega (1024^2), giga (1024^3), tera (1024^4), and peta (1024^5)
-respectively. The suffix is not case sensitive. If prefixed with '0x', the
-value is assumed to be base 16 (hexadecimal). A suffix may include a trailing 'b',
-for instance 'kb' is identical to 'k'. You can specify a base 10 value
-by using 'KiB', 'MiB', 'GiB', etc. This is useful for disk drives where
-values are often given in base 10 values. Specifying '30GiB' will get you
-30*1000^3 bytes.
+Integer. A whole number value, which may contain an integer prefix
+and an integer suffix. 
+
+[integer prefix]number[integer suffix]
+
+The optional integer prefix specifies the number's base. The default 
+is decimal. 0x specifies hexadecimal.
+
+The optional integer suffix specifies the number's units, and includes
+a unit prefix and an optional unit.  The default unit is bytes.
+
+NOTE: For compatibility with old scripts, the unit prefixes are 
+opposite from those specified in the SI and IEC 80000-13 standards.
+
+To specify base2 binary values defined in IEC 80000-13:
+
+.IP
+k means kibi (Ki) or 1024
+.IP
+m means mebi (Mi) or 1024**2
+.IP
+g means gibi (Gi) or 1024**3
+.IP
+t means tebi (Ti) or 1024**4
+.IP
+p means pebi (Pi) or 1024**5
+
+To specify base10 decimal values defined in the International
+System of Units (SI):
+.IP
+ki means kilo (K) or 1000
+.IP
+mi means mega (M) or 1000**2
+.IP
+gi means giga (G) or 1000**3
+.IP
+ti means tera (T) or 1000**4
+.IP
+pi means peta (P) or 1000**5
+
+An optional unit of 'b' may be included (e.g.,  'kb' is the same 
+as 'k'). 
+
+The integer suffix is not case sensitive (e.g., m/mi mean mebi/mega, 
+not milli). 'b' and 'B' both mean byte, not bit.
+
+Examples:
+.IP
+4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
+.IP
+1 MiB: 1048576, 1m, 1024k 
+.IP
+1 MB: 1000000, 1mi, 1000ki
+.IP
+1 TiB: 1073741824, 1t, 1024m, 1048576k
+.IP
+1 TB: 1000000000, 1ti, 1000mi, 1000000ki
 .TP
 .I bool
 Boolean: a true or false value. `0' denotes false, `1' denotes true.




---
Rob Elliott    HP Server Storage



