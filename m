Return-Path: <fio-owner@vger.kernel.org>
Received: from mxi1.enovance.com ([94.143.114.217]:14343 "EHLO
	mxi1.enovance.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3GPHTV (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Jul 2013 03:19:21 -0400
Received: from zimbra.enovance.com (94-143-114-250.enovance.net [94.143.114.250])
	by mxi1.enovance.com (Postfix) with ESMTP id 25EEA126F6
	for <fio@vger.kernel.org>; Tue, 16 Jul 2013 09:19:20 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id 212103C81423
	for <fio@vger.kernel.org>; Tue, 16 Jul 2013 09:19:20 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EQ7f_cjE7Exk for <fio@vger.kernel.org>;
	Tue, 16 Jul 2013 09:19:19 +0200 (CEST)
Received: from localhost (mail-1 [127.0.0.1])
	by zimbra.enovance.com (Postfix) with ESMTP id C99C43C8141B
	for <fio@vger.kernel.org>; Tue, 16 Jul 2013 09:19:19 +0200 (CEST)
Received: from zimbra.enovance.com ([127.0.0.1])
	by localhost (zimbra.enovance.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1eF9uK1Lvgh4 for <fio@vger.kernel.org>;
	Tue, 16 Jul 2013 09:19:19 +0200 (CEST)
Received: from localhost.localdomain (lns-bzn-48f-62-147-157-222.adsl.proxad.net [62.147.157.222])
	by zimbra.enovance.com (Postfix) with ESMTPSA id 5C851492C837
	for <fio@vger.kernel.org>; Tue, 16 Jul 2013 09:19:19 +0200 (CEST)
Message-ID: <51E4F3F6.3030808@enovance.com>
Date: Tue, 16 Jul 2013 09:19:18 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Question about exec_string()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm continuing my experiments with fio and adding features to genfio.
I'm currently adding to genfio the exec_{pre|post}run support.

I'm benching some ceph and so need to reset OSD's caches with echoing in 
drop_cache.
To achieve that, I'm using kash (from kanif) and having the following 
syntaxt :

kash -n m1sw1 -n m1sw2 -n m1sw3 -n m2sw1 -n m2sw3 -- echo 3 > 
/proc/sys/vm/drop_caches

To be able to ssh all this nodes, I need my env to be kept as it relies 
on my ssh-agent.
That's where I do my troubles.

exec_prerun uses exec_string() with does a "sh -c %s'". That does loose 
my env and prevents me from executing my command.

I've been testing by removing the "sh -c" and only keep "%s" which works 
perfectly.
I'm so wondering what was the targeted role of executing sh instead of 
running the command directly.
If you agree about this change, I can provide the patch.

Note also it would be lovely to have an explicit redirection of the 
output as unless it's pretty hard to understand if the command got run 
with its associated output.

Cheers,
Erwan
