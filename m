Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:15437 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab3HHPlx (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 8 Aug 2013 11:41:53 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 170CB124DC
	for <fio@vger.kernel.org>; Thu,  8 Aug 2013 17:41:52 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 1548E72D018
	for <fio@vger.kernel.org>; Thu,  8 Aug 2013 17:41:52 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4B0a0d4wCp1z for <fio@vger.kernel.org>;
	Thu,  8 Aug 2013 17:41:51 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id B7A503C8141F
	for <fio@vger.kernel.org>; Thu,  8 Aug 2013 17:41:51 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NKPoqsjIGVes for <fio@vger.kernel.org>;
	Thu,  8 Aug 2013 17:41:51 +0200 (CEST)
Received: from localhost.localdomain (94-143-112-83.enovance.net [94.143.112.83])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 601143C81404
	for <fio@vger.kernel.org>; Thu,  8 Aug 2013 17:41:51 +0200 (CEST)
Message-ID: <5203BC3F.50209@enovance.com>
Date: Thu, 08 Aug 2013 17:41:51 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: [Pull Request] Updates for fio2gnuplot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hey Jens,

This branch is featuring the requested documentation and features plus 
some fixes when using genfio with files or complex /dev/ naming.

Cheers,

The following changes since commit 7a16102ef84e3db14b6802a06f7f99e2e55af85d:

   Fio 2.1.2 (2013-08-06 09:39:54 -0600)

are available in the git repository at:

   git@github.com:enovance/fio.git erwan/next

for you to fetch changes up to bed59bab819823dffe270435b65ed8feafb52148:

   genfio: Don't consider only /dev/ disk device (2013-08-08 17:40:56 +0200)

----------------------------------------------------------------
Erwan Velu (10):
       fio2gnplot: Print specific message if cmdline parsing fails
       fio2gnuplot: Adding getoplong support for cmdline
       fio2gnuplot: Fixing typo in error message
       fio2gnuplot: Adding verbose option
       fio2gnuplot: Deleting temporary files by default
       fio2gnuplot: Managing temporary files in a better way
       fio2gnuplot: Fixing help message
       fio2gnuplot: Removing .py extension
       fio2gnuplot: Adding manpage
       genfio: Don't consider only /dev/ disk device

  Makefile                                   |   8 ++++++--
  tools/genfio                               |  47 
+++++++++++++++++++++++++++++++++--------------
  tools/plot/{fio2gnuplot.py => fio2gnuplot} |  67 
++++++++++++++++++++++++++++++++++++++++++++++++++----------------
  tools/plot/fio2gnuplot.1                   | 161 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  tools/plot/fio2gnuplot.manpage             | 117 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  5 files changed, 368 insertions(+), 32 deletions(-)
  rename tools/plot/{fio2gnuplot.py => fio2gnuplot} (87%)
  create mode 100644 tools/plot/fio2gnuplot.1
  create mode 100644 tools/plot/fio2gnuplot.manpage
