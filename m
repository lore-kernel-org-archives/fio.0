Return-Path: <fio-owner@vger.kernel.org>
Received: from pbit-mailserver.permabit.com ([66.202.84.83]:37749 "EHLO
	pbit-mailserver.permabit.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580Ab3A2Bbn (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 28 Jan 2013 20:31:43 -0500
From: Ken Raeburn <raeburn@permabit.com>
Subject: path name lengths
Date: Mon, 28 Jan 2013 20:24:12 -0500
Message-ID: <6eham0rdc3.fsf@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I was trying to set up a somewhat perverse test to look at the cost of
using LVMs on Linux, by stacking them many levels deep. When I ran fio,
it crashed before exiting, reporting memory corruption.

I've found a couple issues still present in today's git sources:

The path array in struct disk_util is only 256 bytes long, and there's
no check to avoid overflowing it, so if the string you try to put into
it is
"/sys/block/dm-47/slaves/../../dm-46/slaves/../../dm-45/slaves/../.."
(you get the idea), you can easily scribble past the end of the array,
and the containing disk_util structure.

I'll have a patch for this shortly.

In find_add_disk_slaves, where the code uses readlink on entries found
in the "slaves" subdirectory and appends to the previous directory name,
there is no check for exceeding the size of the automatic character
arrays. Since those arrays are 4KB I'm not having any problems with
them, but it might be good to add checks there.

Ken
