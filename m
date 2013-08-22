Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:53200 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3HVJqz convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 22 Aug 2013 05:46:55 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id 97217A2C24
	for <fio@vger.kernel.org>; Thu, 22 Aug 2013 11:37:59 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (hercules.tks.local [192.168.110.28])
	by iris.tks.local (Postfix) with ESMTP id 4593F3FDD1
	for <fio@vger.kernel.org>; Thu, 22 Aug 2013 11:37:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 4190E1A84009
	for <fio@vger.kernel.org>; Thu, 22 Aug 2013 11:37:59 +0200 (CEST)
Received: from zimbra.thomas-krenn.com ([127.0.0.1])
	by localhost (zimbra.thomas-krenn.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JCJIoP5grLMe for <fio@vger.kernel.org>;
	Thu, 22 Aug 2013 11:37:55 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (zimbra.thomas-krenn.com [127.0.1.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 7FB961A84006
	for <fio@vger.kernel.org>; Thu, 22 Aug 2013 11:37:55 +0200 (CEST)
Date: Thu, 22 Aug 2013 11:37:55 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <1314394180.368686.1377164275463.JavaMail.root@thomas-krenn.com>
In-Reply-To: <112541105.368381.1377163637545.JavaMail.root@thomas-krenn.com>
Subject: write_iops_log/write_bw_log command line parameter bug
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

it seems that the command line options "write_iops_log" and "write_bw_log" don't work as they are described in the man page:
"If no filename is given with this option, the default filename of "jobname_type.log" is used."

Unfortunately the files/filenames are not created automatically by fio:
# fio --name=test --direct=1 --refill_buffers --filesize=1G --bs=8k --rw=randread --ioengine=libaio --runtime=60 --write_iops_log --write_bw_log
[...]
# ls
lost+found  test.1.0  --write_bw_log_iops.log

If I specify the filenames everything is fine:
# rm ./--write_bw_log_iops.log
# fio --name=test --direct=1 --refill_buffers --filesize=1G --bs=8k --rw=randread --ioengine=libaio --runtime=60 --write_iops_log=rr-iops --write_bw_log=rr-bw
[...]
# ls
lost+found  rr-bw_bw.log  rr-iops_iops.log  test.1.0

I am using fio version fio-2.1.2-13-g3e10.

Best regards, Georg
--
: Georg Schönberger
: Research & Development Executive
: Thomas-Krenn.AG | The server-experts
: http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki
