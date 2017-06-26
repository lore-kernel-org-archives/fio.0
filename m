Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39155 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751340AbdFZOwK (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 26 Jun 2017 10:52:10 -0400
Subject: Re: [PATCH 1/4] stat: Print one-line iops stat
References: <20170623222738.5146-1-aherrmann@suse.com>
 <20170623222738.5146-2-aherrmann@suse.com>
 <AT5PR84MB0082C10FAD4DA42F5F7B1295ABDF0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
From: Jens Axboe <axboe@fb.com>
Message-ID: <67ebce2a-bdcf-90d2-bd43-0a353cc45ec2@fb.com>
Date: Mon, 26 Jun 2017 08:52:01 -0600
MIME-Version: 1.0
In-Reply-To: <AT5PR84MB0082C10FAD4DA42F5F7B1295ABDF0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Andreas Herrmann <aherrmann@suse.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 06/26/2017 08:30 AM, Elliott, Robert (Persistent Memory) wrote:
> 
> 
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Andreas Herrmann
>> Sent: Friday, June 23, 2017 5:28 PM
>> To: Jens Axboe <axboe@fb.com>
>> Cc: fio@vger.kernel.org
>> Subject: [PATCH 1/4] stat: Print one-line iops stat
>>
>> This adds basic iops statistics (likewise to what we already have for
>> bandwidth) to normal and json fio output. Example for normal output:
>>
>>    bw (  KiB/s): min=42192, max=162068, per=0.10%, avg=93236.21,
>> stdev=22180.02
>>    iops : min=21090, max=81020, avg=46606.84, stdev=11088.40
>>     lat (usec) : 2=55.13%, 4=21.11%, 10=0.36%, 20=0.03%, 50=23.14%
> ...
>> +		log_buf(out, "   iops : min=%5llu, max=%5llu, avg=%5.02f, "
>> +			"stdev=%5.02f\n", min, max, mean, dev);
> 
> Seven more spaces are needed to line up the : characters in all the rows.

Good catch, I fixed that up.

-- 
Jens Axboe

