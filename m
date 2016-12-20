Return-Path: <fio-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48414 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932357AbcLTQyH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Dec 2016 11:54:07 -0500
Subject: Re: [PATCH v2] fio: add device dax engine
References: <148115127004.159869.15069122701228994037.stgit@djiang5-desk3.ch.intel.com>
 <DF4PR84MB016903FA84DE6978FFF39083AB900@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <10bb9543-45e4-6782-45bd-1e4a47226b38@intel.com>
Date: Tue, 20 Dec 2016 09:54:06 -0700
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB016903FA84DE6978FFF39083AB900@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>



On 12/20/2016 09:30 AM, Elliott, Robert (Persistent Memory) wrote:
> 
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Dave Jiang
>> Subject: [PATCH v2] fio: add device dax engine
>>
>> diff --git a/configure b/configure
> ...
>> @@ -136,6 +136,7 @@ exit_val=0
>>  gfio_check="no"
>>  libhdfs="no"
>>  pmemblk="no"
>> +devdax="no"
>>  disable_lex=""
>>  prefix=/usr/local
>>
>> @@ -174,6 +175,8 @@ for opt do
>>    ;;
>>    --enable-pmemblk) pmemblk="yes"
>>    ;;
>> +  --enable-devdax) devdax="yes"
>> +  ;;
>>    --disable-lex) disable_lex="yes"
>>    ;;
>>    --enable-lex) disable_lex="no"
>> @@ -205,6 +208,7 @@ if test "$show_help" = "yes" ; then
>>    echo "--disable-gfapi        Disable gfapi"
>>    echo "--enable-libhdfs       Enable hdfs support"
>>    echo "--enable-pmemblk       Enable NVML libpmemblk support"
>> +  echo "--enable-devdax        Enable NVM Device Dax support"
>>    echo "--disable-lex          Disable use of lex/yacc for math"
>>    echo "--enable-lex           Enable use of lex/yacc for math"
>>    echo "--disable-shm          Disable SHM support"
> 
> I didn't notice that pmemblk was not automatically detected, and devdax
> is using the same approach.  Could they both automatically be installed
> if NVML is detected on the build system machine (with a --disable-libnuma
> argument to override if needed)?

I can look into how to enable this if there are no objections from others.

> 
> Also, "NVM" should be "NVML" in that help message.
> 
> 
