Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44184 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3A2VRN (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 29 Jan 2013 16:17:13 -0500
Date: Tue, 29 Jan 2013 22:16:29 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Group reporting with latency and IOPS
Message-ID: <20130129211629.GL8800@kernel.dk>
References: <20130129130212.GB8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D243A@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129134652.GF8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D26D5@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129135401.GG8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D27A5@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129201005.GH8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D396C@SACEXCMBX02-PRD.hq.netapp.com>
 <20130129203239.GJ8800@kernel.dk>
 <843E15216120C047928F6879B0E2D9240F6D3A0D@SACEXCMBX02-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <843E15216120C047928F6879B0E2D9240F6D3A0D@SACEXCMBX02-PRD.hq.netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> On Tue, Jan 29 2013, Neto, Antonio Jose Rodrigues wrote:
> > Jens, sorry to bother you again, but I am trying to apply the I've got 
> > this=  error. Could you please help me how to fix it?
> 
> I forgot to push a previous change out. Pull again and try applying, should apply without fuzz.
> 
> I am afraid that I am doing something wrong.... The latest change (pull) was in client.c. I pulled, copied the whole directory but same error. 
> 
> [root@mickey fio]# patch <a.diff
> patching file client.c
> Hunk #1 succeeded at 595 with fuzz 1.
> patching file eta.c
> patch: **** malformed patch at line 38: @@ -235,19 +236,32 @@ static void calc_rate(unsigned long mtime, unsigned long long *io_bytes,

Your mailer or MTA has corrupted the patch. I've attached a zip file for
you, that has a better chance of surviving broken mail setups.

-- 
Jens Axboe


--ZwgA9U+XZDXt4+m+
Content-Type: application/x-zip-compressed
Content-Disposition: attachment; filename="patch.zip"
Content-Transfer-Encoding: base64

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
AAAA

--ZwgA9U+XZDXt4+m+--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


