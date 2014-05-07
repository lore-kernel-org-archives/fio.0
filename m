Return-Path: <axboe@kernel.dk>
Message-ID: <536987F7.6030709@kernel.dk>
Date: Tue, 06 May 2014 19:10:15 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Meta verification regression starting with fio 2.1.5
References: <536928FE.6020109@skyera.com> <53695B3C.8060201@kernel.dk> <53697FED.5060001@skyera.com>
In-Reply-To: <53697FED.5060001@skyera.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Stoo Davies <sdavies@skyera.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-05-06 18:35, Stoo Davies wrote:
> On 05/06/2014 02:59 PM, Jens Axboe wrote:
>> 2.1.5 did indeed change when the IO was logged for verification, so that
>> does explain why it fails for you now. That's a problem.
>>
>> Can you try with this patch? I'm not going to commit it yet, I want to
>> carefully audit all paths to ensure we also unlog or trim an io_piece,
>> if we don't fully complete it.
>>
> 10 loops through the powerfail test and all the hosts are still happy.
> Looks good to me, thanks for the fast response.

Thanks a lot for reporting it, I have now committed a patch that is 
basically what I sent you, but catches the partial completion case as well.

-- 
Jens Axboe


