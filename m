Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:44891 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaAVUwZ convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 22 Jan 2014 15:52:25 -0500
Received: by mail-la0-f53.google.com with SMTP id e16so755159lan.26
        for <fio@vger.kernel.org>; Wed, 22 Jan 2014 12:52:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Strange aggregate BW
From: grant <626542@gmail.com>
In-Reply-To: <52DD94E1.2060607@aeoncomputing.com>
Date: Thu, 23 Jan 2014 00:52:20 +0400
Content-Transfer-Encoding: 8bit
Message-Id: <1D880D06-8D06-4E97-A7AC-EE7A5B44785E@gmail.com>
References: <748581DD-9A26-41D7-A537-58F6D6741B33@gmail.com> <52DD94E1.2060607@aeoncomputing.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: fio@vger.kernel.org


As I know 3TB/7200RPM drive used. I suppose sustained data transfer for it <= 150 MB/s.

On 21 янв. 2014 г., at 1:28, Jeff Johnson <jeff.johnson@aeoncomputing.com> wrote:

> What make/model of NL-SAS disk drive? The 4TB/7200RPM drives are pushing sequential media rates of >150MB/sec.
> 
> On 1/20/14, 1:23 PM, grant wrote:
>> Hello,
>> 
>> I’ve got a HWRAID with 10 NL-SAS HDDs.
>> All of them used in logical volume RAID6.
>> I’ve tried to benchmark created volume with FIO v2.1.4:
>> 
>> # cat seqwrite.fio
>> [write]
>> blocksize=512k
>> filename=/dev/sda
>> rw=write
>> direct=1
>> buffered=0
>> ioengine=libaio
>> iodepth=1
>> runtime=10m
>> numjobs=16
>> 
>> #./fio seqwrite.fio
>> 
>> FIO returns:
>> ...
>> Run status group 0 (all jobs):
>>   WRITE: io=127958MB, aggrb=2132.5MB/s, minb=56530KB/s, maxb=229141KB/s..
>> 
>> 2132 / 10 ~ 200 MB/s per HDD, is that possible???
> 
> -- 
> ------------------------------
> Jeff Johnson
> Co-Founder
> Aeon Computing
> 
> jeff.johnson "at" aeoncomputing dot com
> www.aeoncomputing.com
> t: 858-412-3810 x1001   f: 858-412-3845
> 
> 4170 Morena Boulevard, Suite D - San Diego, CA 92117
> 
> High-performance Computing / Lustre Filesystems / Scale-out Storage
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

