Return-Path: <fio-owner@vger.kernel.org>
Received: from masquerade.micron.com ([137.201.242.130]:44254 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2BPRdY convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 16 Feb 2012 12:33:24 -0500
Received: from mail.micron.com (ntxboicas04.micron.com [137.201.20.214])
	by masquerade.micron.com (8.13.6/8.13.6) with ESMTP id q1GHXNds005900
	for <fio@vger.kernel.org>; Thu, 16 Feb 2012 10:33:23 -0700
From: "Bill Hooper (whooper)" <whooper@micron.com>
Subject: RE: Formats for log files
Date: Thu, 16 Feb 2012 17:33:23 +0000
Message-ID: <8C39003C166535489D52AF2C9D8C58BC1A316D31@NTXBOIMBX04.micron.com>
References: <8C39003C166535489D52AF2C9D8C58BC1A316C92@NTXBOIMBX04.micron.com>
 <953A2B33-81B7-4ECC-9E21-4C6393CF8B7E@joshcarter.com>
In-Reply-To: <953A2B33-81B7-4ECC-9E21-4C6393CF8B7E@joshcarter.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks for the information. I suspected that was the format. I do notice that I do not always have the block size in the log. I am using version 2.0 and will try a more recent version.

It appears that when I set the numjobs parameter the log files will contain the data from each job concatenated. I also notice that the times for each job is not synchronized between jobs. The question is how do I merge the data from each job to consolidate the data?

Bill Hooper
Micron

> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Josh Carter
> Sent: Wednesday, February 15, 2012 5:26 PM
> To: Bill Hooper (whooper); fio@vger.kernel.org
> Subject: Re: Formats for log files
> 
> Bill,
> 
> Format of entries is:
> 
>   time, rate/latency, data direction, block size
> 
> Time: in milliseconds. Bandwidth logs are usually 500 or 1000ms apart; that
> can be controlled by the config file with "bwavgtime=[x ms]".
> 
> Rate/latency: for bandwidth, this is in KB/sec. For latency, it's
> microseconds.
> 
> Data direction: 0 is read, 1 is write.
> 
> Block size: block size of IOs in bytes.
> 
> For those using R to analyze log files, I have some useful stuff here:
> 
>   https://github.com/joshcarter/fio_tools
> 
> In particular, /analysis/fio_log_parsers.R has read_bw_log() and
> read_lat_log() functions.
> 
> Best regards,
> Josh
> 
> On Feb 15, 2012, at 2:42 PM, Bill Hooper (whooper) wrote:
> 
> > Where can I find documentation for the format of the write_bw_log,
> write_iops_log, and write_lat_log output?
> >
> > Bill Hooper
> > Micron
> > --
> > To unsubscribe from this list: send the line "unsubscribe fio" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
