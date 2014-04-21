Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44654 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaDUQkk convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 21 Apr 2014 12:40:40 -0400
Received: by mail-ie0-f176.google.com with SMTP id rd18so4000380iec.7
        for <fio@vger.kernel.org>; Mon, 21 Apr 2014 09:40:39 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: runtime resets eta after countdown
From: Vasu Kulkarni <vasu.kulkarni@gmail.com>
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB1086BE95@DAGN05B-E6.exg6.exghost.com>
Date: Mon, 21 Apr 2014 09:40:36 -0700
Content-Transfer-Encoding: 8BIT
Message-Id: <8BEF02A4-AC51-4C98-8495-00FECE136C9E@gmail.com>
References: <F73CB16A-07C1-4E7B-AD65-2045F7538FBF@gmail.com> <A7A1D348E34E024BBC74480FB93A2EAB1086BE95@DAGN05B-E6.exg6.exghost.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

What is the workaround for this issue? I tried SIGINT but it doesn't always generate the numbers 

randon_rw1: (groupid=0, jobs=1): err= 0: pid=29726: Mon Apr 21 00:20:13 2014
    lat (usec) : 2=0.04%, 4=32.08%, 10=17.79%, 20=0.03%, 50=8.33%
    lat (usec) : 100=41.23%, 250=0.41%, 500=0.02%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%, 10=0.03%, 20=0.01%, 50=0.01%
    lat (msec) : 100=0.01%, 250=0.01%, 500=0.01%
  cpu          : usr=0.00%, sys=0.00%, ctx=11640791, majf=3, minf=47
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=9359258/w=9362934/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):

