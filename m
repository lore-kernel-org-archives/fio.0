Return-Path: <fio-owner@vger.kernel.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3]:56719 "EHLO
	averel.grnet-hq.admin.grnet.gr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754486Ab3CLGo4 (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Mar 2013 02:44:56 -0400
Message-ID: <513ECEFB.1060803@grnet.gr>
Date: Tue, 12 Mar 2013 08:45:15 +0200
From: Alex Pyrgiotis <apyrgio@grnet.gr>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] Add a simple test for LFSR generator
References: <1362746224-5162-1-git-send-email-apyrgio@grnet.gr> <1362746224-5162-3-git-send-email-apyrgio@grnet.gr> <513DFD85.2080107@cesnet.cz>
In-Reply-To: <513DFD85.2080107@cesnet.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jiri Horky <jiri.horky@cesnet.cz>
Cc: fio@vger.kernel.org, synnefo-devel@googlegroups.com

On 03/11/2013 05:51 PM, Jiri Horky wrote:
> Hi Alex,
>
> I just used your implementation in a different project as well, thanks 
> for it :) One small correction, I think that the last line of:
>
> On 03/08/2013 01:37 PM, Alex Pyrgiotis wrote:
>> +    /* Check if all expected numbers within range have been 
>> calculated */
>> +    r = 0;
>> +    if (verify) {
>> +        fprintf(stderr, "Verifying results... ");
>> +        for (i = 0; i < numbers; i++) {
>> +            if (*(uint8_t *)(v + 1) != 1) {
> should be:
>
>             if (*(uint8_t *)(v + i) != 1) {
>
> (not +1, but +i).
>
>

Hi Jiri,

I'm glad you found the implementation useful.
Your observation is correct. I'll send a new patch that fixes this 
issue, among other things.

Thanks,
Alex

-- 
Alex | apyrgio@grnet.gr

