Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/4] Sync fio(1) man page with HOWTO (remaining sections)
Date: Sun, 13 Aug 2017 22:18:57 +0300
Message-Id: <20170813191901.33195-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is the continuation of below series of patches to sync the man page
with HOWTO. It starts off from where it left off, which is job parameters
section.

[PATCH 0/7] Sync fio(1) man page with HOWTO
http://www.spinics.net/lists/fio/msg06008.html

These patches basically just sync the existing man page contents with
HOWTO, and add/backport some minor fixes to HOWTO. They do not create
any new contents that do not exist in either of the documents, while
formats (e.g. indentations, directives, quotations, etc) are modified
for some sections so that the entire man page has consistent style and
resembles HOWTO.

The patch 1/4 covers the entire job parameters section which consists
of huge amount of diffs. I didn't separate them into smaller patches
(e.g. 1 patch for 1 job parameter category sub section), because the
entire syncing includes huge amount of reordering plus modification
within the entire file, as the job parameters in the existing man page
were not categorized by the parameter types, and separating them into
smaller patches doesn't make them any clear, but rather unclear.

Above applies to patch 2/4 as well which covers the rest of the HOWTO.

Also note that there are still sections in HOWTO that are not in the
man page. For example, these patches add all the missing options and
parameters, but do not cover details of writing the job files with
examples of job files, as they have never been covered in the man page.
They could be imported to the man page as well (depending on whether
we want the man page to be identical to HOWTO), but I have separated
the creation of new sections from syncing the existing ones with HOWTO.

The man page size (not ./fio.1 size) has increased by about 300+ lines,
from around 1700 to 2000. Counting from prior to the previous series of
the patches (i.e. since bdd88be^), it has increased by about 400 lines.

Tomohiro Kusumi (4):
  man: sync "JOB PARAMETERS" section with HOWTO
  man: sync "OUTPUT" section and after with HOWTO
  man: minor fixes for sections before "JOB PARAMETERS" for consistency
  HOWTO: minor fixes and backports from man page

 HOWTO |  205 ++--
 fio.1 | 4238 +++++++++++++++++++++++++++++++++++++----------------------------
 2 files changed, 2535 insertions(+), 1908 deletions(-)

-- 
2.9.4


