Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34441 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbdF2RjG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Jun 2017 13:39:06 -0400
Received: by mail-pf0-f174.google.com with SMTP id s66so53864987pfs.1
        for <fio@vger.kernel.org>; Thu, 29 Jun 2017 10:39:06 -0700 (PDT)
Received: from [10.125.26.39] ([8.39.141.5])
        by smtp.gmail.com with ESMTPSA id r69sm14222571pfg.28.2017.06.29.10.39.05
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Jun 2017 10:39:05 -0700 (PDT)
From: "Forrest, Jon" <nobozo@gmail.com>
Reply-To: Jon.Forrest@dolby.com
Subject: Re: Strange Uncorrectable Section Count Produced By Fio
References: <ece2c605-f015-6479-2b3b-ad30f07b447c@dolby.com>
 <CY4PR10MB1477786895ADFF04303497739DD20@CY4PR10MB1477.namprd10.prod.outlook.com>
Message-ID: <5965d266-6101-47dc-ec97-e7c8466293f2@dolby.com>
Date: Thu, 29 Jun 2017 10:39:04 -0700
MIME-Version: 1.0
In-Reply-To: <CY4PR10MB1477786895ADFF04303497739DD20@CY4PR10MB1477.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>



On 6/29/2017 10:21 AM, Todd Lawall wrote:
> 
> Correct me if I'm wrong everybody, but those look suspiciously like
> errors coming from the kernel/driver rather than FIO.

I agree but see below.

> John, you could confirm this by looking for these messages in the output of the
> 'dmesg' command.   If they're from the driver, then there's further
> questions for the authors of that code that you'd need to ask.

Much to my surprise, 'dmesg' doesn't include those messages.

Also, I received 12 email messages sent to 'root' from 'root' on that
system with the same error messages, one message per disk.

I hadn't thought these messages came from 'fio' directly, but
I don't know where they come from. Whatever is producing them
seems to be confused because the number of errors are incorrect.

Jon Forrest
Dolby Laboratories, Inc.
