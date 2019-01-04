Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk1-f177.google.com ([209.85.222.177]:43143 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfADRhL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Jan 2019 12:37:11 -0500
Received: by mail-qk1-f177.google.com with SMTP id z18so5943394qkj.10
        for <fio@vger.kernel.org>; Fri, 04 Jan 2019 09:37:10 -0800 (PST)
From: Vincent Fu <vincentfu@gmail.com>
Subject: Re: Reporting mixed latency percentiles
References: <CAF+0mvkvfO5Te7yRk4B5x4yndbM=2e+7qMZVwo-W2ZYZVpUfOA@mail.gmail.com>
Message-ID: <7d6537bd-0ac3-bb7c-f6c3-334406b1fe82@gmail.com>
Date: Fri, 4 Jan 2019 12:37:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAF+0mvkvfO5Te7yRk4B5x4yndbM=2e+7qMZVwo-W2ZYZVpUfOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org

On 1/2/19 1:22 PM, Matthew Eaton wrote:
> Hello fio group,
> 
> I have a general question. Normally fio outputs latency percentiles
> for mixed reads and writes separately. What is the proper way to
> report a unified read/write percentile? Do you max them? Sum them?
> 
> Thanks!
> 

fio has a unified_rw_reporting option that should get you what you want.

In general, you would need the raw data to calculate percentiles when 
combining two datasets. This can be obtained with output-format=json+

