Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/3] HOWTO: fix wrong "here follows the complete list of fio job parameters" position
Date: Tue,  1 Aug 2017 22:49:27 +0300
Message-Id: <20170801194928.50146-3-tkusumi@tuxera.com>
In-Reply-To: <20170801194928.50146-1-tkusumi@tuxera.com>
References: <20170801194928.50146-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

f80dba8d('Convert documentation to reStructured text.')
made this sentence appear in the wrong place.
It should appear before "Units" job parameter section.

The man page has this right as it's not synced (will be soon).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index 80d1c05..3a02cc6 100644
--- a/HOWTO
+++ b/HOWTO
@@ -576,6 +576,8 @@ Parameter types
 **float_list**
 	A list of floating point numbers, separated by a ':' character.
 
+With the above in mind, here follows the complete list of fio job parameters.
+
 
 Units
 ~~~~~
@@ -622,9 +624,6 @@ Units
 		Bit based.
 
 
-With the above in mind, here follows the complete list of fio job parameters.
-
-
 Job description
 ~~~~~~~~~~~~~~~
 
-- 
2.9.4


