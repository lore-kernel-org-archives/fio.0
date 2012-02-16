Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp182.dfw.emailsrvr.com ([67.192.241.182]:56648 "EHLO
	smtp182.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab2BPBgl convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 15 Feb 2012 20:36:41 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1257)
Subject: Re: Formats for log files
From: Josh Carter <public@joshcarter.com>
In-Reply-To: <8C39003C166535489D52AF2C9D8C58BC1A316C92@NTXBOIMBX04.micron.com>
Date: Wed, 15 Feb 2012 18:26:09 -0700
Content-Transfer-Encoding: 8BIT
Message-Id: <953A2B33-81B7-4ECC-9E21-4C6393CF8B7E@joshcarter.com>
References: <8C39003C166535489D52AF2C9D8C58BC1A316C92@NTXBOIMBX04.micron.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Bill Hooper (whooper)" <whooper@micron.com>, fio@vger.kernel.org

Bill,

Format of entries is:

  time, rate/latency, data direction, block size

Time: in milliseconds. Bandwidth logs are usually 500 or 1000ms apart; that can be controlled by the config file with "bwavgtime=[x ms]".

Rate/latency: for bandwidth, this is in KB/sec. For latency, it's microseconds.

Data direction: 0 is read, 1 is write.

Block size: block size of IOs in bytes.

For those using R to analyze log files, I have some useful stuff here:

  https://github.com/joshcarter/fio_tools

In particular, /analysis/fio_log_parsers.R has read_bw_log() and read_lat_log() functions.

Best regards,
Josh

On Feb 15, 2012, at 2:42 PM, Bill Hooper (whooper) wrote:

> Where can I find documentation for the format of the write_bw_log, write_iops_log, and write_lat_log output?
> 
> Bill Hooper
> Micron
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

