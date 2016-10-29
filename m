Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:21107 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752423AbcJ2Ah4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2016 20:37:56 -0400
Subject: Re: fio crash on windows when using json output
References: <BY2PR0701MB2039BAE87219973B20F0FB8BAFCF0@BY2PR0701MB2039.namprd07.prod.outlook.com>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <b5af750c-b0bb-a75c-fa9d-05c004458fe8@cran.org.uk>
Date: Fri, 28 Oct 2016 18:37:54 -0600
MIME-Version: 1.0
In-Reply-To: <BY2PR0701MB2039BAE87219973B20F0FB8BAFCF0@BY2PR0701MB2039.namprd07.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shahar Glixman <sglixman@velostrata.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 9/28/2016 2:21 PM, Shahar Glixman wrote:
> I am trying to run fio on windows (2012 core), and getting sporadic crashes  (~ 1 out of 3 runs) -
> Tried both 2.13 (taken from bluestop site: fio-2.13-x64.zip)
> And also compiled 2.14 from sources.

I haven't been able to replicate the crash in either current or older 
code on my Windows system. Could you check if a build of the current git 
code also crashes, please?

Thanks.
Bruce
