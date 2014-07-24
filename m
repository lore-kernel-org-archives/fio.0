Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.190]:6217 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778AbaGXMtE convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 24 Jul 2014 08:49:04 -0400
Received: from iris.intern.thomas-kren.com (iris.intern.thomas-krenn.com [192.168.110.42])
	by mail.thomas-krenn.com (Postfix) with ESMTP id 8CC439F930
	for <fio@vger.kernel.org>; Thu, 24 Jul 2014 14:42:20 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (webmail.thomas-krenn.com [192.168.110.28])
	by iris.intern.thomas-kren.com (Postfix) with ESMTP id 6D9A73FE48
	for <fio@vger.kernel.org>; Thu, 24 Jul 2014 14:42:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 69FC41A84002
	for <fio@vger.kernel.org>; Thu, 24 Jul 2014 14:42:20 +0200 (CEST)
Received: from zimbra.thomas-krenn.com ([127.0.0.1])
	by localhost (zimbra.thomas-krenn.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id Sy0aamUCas8U for <fio@vger.kernel.org>;
	Thu, 24 Jul 2014 14:42:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id AE1C91A8400E
	for <fio@vger.kernel.org>; Thu, 24 Jul 2014 14:42:09 +0200 (CEST)
Received: from zimbra.thomas-krenn.com ([127.0.0.1])
	by localhost (zimbra.thomas-krenn.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fmtTwmO2Ruav for <fio@vger.kernel.org>;
	Thu, 24 Jul 2014 14:42:09 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (zimbra.thomas-krenn.com [127.0.1.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 9A7761A84002
	for <fio@vger.kernel.org>; Thu, 24 Jul 2014 14:42:09 +0200 (CEST)
Date: Thu, 24 Jul 2014 14:42:09 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <1997154026.44524.1406205729559.JavaMail.zimbra@thomas-krenn.com>
In-Reply-To: <1528502860.42759.1406203872658.JavaMail.zimbra@thomas-krenn.com>
References: <1528502860.42759.1406203872658.JavaMail.zimbra@thomas-krenn.com>
Subject: Using libaio with buffered IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

in the fio man-page you are writing:
"Even async engines my impose OS restrictions causing the desired depth not to be achieved.This may happen on Linux when using libaio and not setting direct=1, since buffered IO is not async on that OS."
(there's also a typo, I think it should be "may" instead of "my")

Nevertheless it is possible to use fio with libaio and buffered IO:
$ fio --rw=write --name=test --size=20M --runtime=60 --time_based --iodepth=64 --ioengine=libaio
[...]
IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.6%, >=64=98.8%

Could you point out the limitations that come up with libaio<->buffered IO (page cache)?

Thanks, Georg
-- 
: Georg Schönberger
: Web Operations & Knowledge Transfer
: Thomas-Krenn.AG | The server-experts
: http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki
