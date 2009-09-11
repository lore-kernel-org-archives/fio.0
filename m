Return-Path: <Alan.Brunelle@hp.com>
Subject: Re: Bug in fio: infinite loop when using two volumes crafted from  one  MD?
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
In-Reply-To: <20090911163539.GK14984@kernel.dk>
References: <1252684789.5814.29.camel@cail>
	 <20090911163539.GK14984@kernel.dk>
Content-Type: multipart/mixed; boundary="=-1Vd7JLGZWL/X0q68xZQc"
Date: Fri, 11 Sep 2009 15:03:40 -0400
Message-Id: <1252695820.5814.31.camel@cail>
Mime-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


--=-1Vd7JLGZWL/X0q68xZQc
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Well, the attached patch appears to fix the problem: When looking to add
an underlying device we first check to see if its in the list of current
devices. If so, we skip this add. 

As I know next to nothing about the innards of fio, I'd be a little
leery of taking this in, but at least it allows me to proceed! :-)

Alan

--=-1Vd7JLGZWL/X0q68xZQc
Content-Disposition: attachment; filename="0001-Bug-fix-handles-disk-device-used-multiple-times.patch"
Content-Type: text/x-patch; name="0001-Bug-fix-handles-disk-device-used-multiple-times.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

From 199a61fe53340c3ebd93567d22e16a95cca3aaeb Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Fri, 11 Sep 2009 14:57:10 -0400
Subject: [PATCH] Bug fix: handles disk device used multiple times

There were issues in having the same underlying device being referenced
multiple times (via different paths) when reporting storage I/O
statistics. As an example: having two (or more) LVM2/DM volumes crafted
out of the same MD array.

This patch simply skips over any devices previously seen.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 diskutil.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/diskutil.c b/diskutil.c
index cb15882..62149d9 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -221,6 +221,13 @@ static void find_add_disk_slaves(struct thread_data *td, char *path,
 			return;
 		}
 
+		/*
+		 * See if this maj,min already exists
+		 */
+		slavedu = disk_util_exists(majdev, mindev);
+		if (slavedu)
+			continue;
+
 		sprintf(temppath, "%s/%s", slavesdir, slavepath);
 		__init_per_file_disk_util(td, majdev, mindev, temppath);
 		slavedu = disk_util_exists(majdev, mindev);
-- 
1.6.0.4


--=-1Vd7JLGZWL/X0q68xZQc--


