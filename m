Return-Path: <fio-owner@vger.kernel.org>
Received: from host-181-75-169-83.static.internet-fr.net ([83.169.75.181]:52271
	"EHLO seanodes.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753535AbYK0QYI (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 27 Nov 2008 11:24:08 -0500
Message-ID: <492EC9A3.5090103@seanodes.com>
Date: Thu, 27 Nov 2008 17:24:03 +0100
From: Erwan Velu <erwan@seanodes.com>
MIME-Version: 1.0
Subject: Re: Inconsency between cli output and gnuplot
References: <49243E53.10309@seanodes.com>
In-Reply-To: <49243E53.10309@seanodes.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Erwan Velu wrote:
> My 1.23 fio ouput display :
>
>  read : io=32,003MiB, bw=131MiB/s, iops=1,362, runt=250326msec
>    slat (usec): min=13, max=145, avg=16.69, stdev= 3.39
>    clat (msec): min=31, max=129, avg=46.94, stdev= 7.24
>
> clat output of gnuplot reports units in msec. The clat gnuplot output 
> show a msec label on the y axis but trace some usec.
>
> slat cli reports values that doesn't match at all what is viewable 
> from gnuplot output. Averagage is said to be 16 on the cli whereas the 
> gnuplot trace shows 20 at min.
> Max is said to be 145 for slat but displayed at 60 on the gnuplot.
> Slat is also said to be usec on the cli but shown as msec on the y 
> axis of the gnuplot.
>
> Complete archive showing that could be downloaded at 
> http://konilope.linuxeries.org/tmp/localr.tar.bz2
>
> It seems that units may vary from the cli output regarding the range 
> of results. I have some case where clat is shown in usec instead of 
> msec. Maybe that what confuse the gnuplot output.
> Like in :
>  write: io=32,003MiB, bw=124MiB/s, iops=1,294, runt=263681msec
>    slat (usec): min=12, max=71, avg=15.43, stdev= 2.72
>    clat (usec): min=663, max=1,537K, avg=49431.63, stdev=108787.82
>    bw (KiB/s) : min=    0, max=171311, per=99.91%, avg=127152.93, 
> stdev=21619.46
>
What's your opinion on that ?

-- 
Erwan Velu
Pre-Sales Engineer
Seanodes
http://www.seanodes.com
+33 (0)1 41 22 13 83

