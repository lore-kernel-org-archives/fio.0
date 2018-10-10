Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:44829 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbeJKDUh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Oct 2018 23:20:37 -0400
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (1.0)
Subject: Re: fio on vmware esxi
From: Eliezer Nebab <eliezer@integritech.solutions>
In-Reply-To: <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com>
Date: Wed, 10 Oct 2018 14:56:53 -0500
Content-Transfer-Encoding: 8bit
Message-Id: <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions>
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions> <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Beierl, Mark" <Mark.Beierl@dell.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks for the quick response Mark.

Yes, I was looking for documentation or guide on if fio can be compiled or installed on esxi servers.  
 
From your response it looks like (compile or precompiled) neither works.

Thank you.

Eliezer


> On Oct 10, 2018, at 2:05 PM, Beierl, Mark <Mark.Beierl@dell.com> wrote:
> 
> Are you asking if FIO can be built or run on the hypervisor itself, like via ssh?
> 
> I have tried a test before where I statically compiled FIO and copied it to an ESXi server, but I was never able to get any jobs to start.  Not sure if the kernel supports the fork() or whatever call FIO uses to spawn the job processes.  So, I’m not sure it can be done.  ESXi is not a general purpose OS, so it lacks some features.
> 
> Regards,
> Mark
> 
> Mark Beierl
> SW System Sr Principal Developer
> Dell EMC | Cloud & Communication Service Provider Solution
> Mark.Beierl@Dell.com
> 
> On 2018-10-10, 14:24, "fio-owner@vger.kernel.org on behalf of eliezer@integritech.solutions" <fio-owner@vger.kernel.org on behalf of eliezer@integritech.solutions> wrote:
> 
> 
>    [EXTERNAL EMAIL] 
>    Please report any suspicious attachments, links, or requests for sensitive information.
> 
> 
>    Is fio supported on vmware esxi 5 and 6 servers?  Does anyone have any
>    helpful guides as to how to install it on vmware?  I've searched google but
>    could not find any.  The only reference to fio+vmware is Disable libaio for
>    ESXi build - bug#80
> 
>    Thank you in advance.
> 
>    Regards,
>    Eliezer
> 
> 
> 


