Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:54522 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753198AbdJSQdi (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Oct 2017 12:33:38 -0400
Received: by mail-qt0-f173.google.com with SMTP id z19so15155406qtg.11
        for <fio@vger.kernel.org>; Thu, 19 Oct 2017 09:33:38 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
Subject: Re: FIO3.0 Json+ QoS bins
References: <CAKwzdDqAt1anq1yKCEb-q_Fgztr5HwnXyiRqbiz9zHUtyGu5Xg@mail.gmail.com>
Message-ID: <c576d3ec-9c8e-346b-7630-88c2b75c9d19@gmail.com>
Date: Thu, 19 Oct 2017 12:33:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAKwzdDqAt1anq1yKCEb-q_Fgztr5HwnXyiRqbiz9zHUtyGu5Xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>, fio@vger.kernel.org

On 18-Oct-17 21:19, abhishek koundal wrote:
> All,
> Recent changes in the FIO3.0 in the json+ format doesn't show binning
> as pre 2.99 version. i really like the new flow   it as it saves file
> space and also just shows relevant buckets populated. (kudos).
> But the clat_histogram still shows 1856 buckets format and binning, is
> there a reason why this is not being updated for clat_histogram ?
> 
> Really appreciate your support cheers!!!
> 

The --write_hist_log data is trickier to shrink because it is in CSV 
format without column labels, whereas the json+ latency bins have bin 
labels along with the counts. Dropping the 0 clat_hist bins would 
require a fundamental change in the output format.

You could always adjust the --log_hist_coarseness value to reduce the 
size of the clat_hist output, but of course this comes at the cost of 
reduced resolution.

Vincent
