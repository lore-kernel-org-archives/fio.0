Return-Path: <axboe@kernel.dk>
Message-ID: <530E6056.2020309@kernel.dk>
Date: Wed, 26 Feb 2014 13:44:54 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio replay
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com> <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org> <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com> <530E2933.2080903@kernel.dk>
In-Reply-To: <530E2933.2080903@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Lamkin, Eric" <Eric.Lamkin@lsi.com>, David Nellans <david@nellans.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-02-26 09:49, Jens Axboe wrote:
> On 2014-02-26 06:23, Lamkin, Eric wrote:
>> David,
>>
>> Thanks for responding.
>> I sent the below out last week but didn't get a reply so thought I'd
>> try a simpler 'what works' tactic this morning.
>> As seen in the below I'm using 2.0.10.
>
> I just ran a quick test here, current -git seems to work fine for me. It
> might be a bit finicky in that the error handling isn't stellar, which
> I'm thinking could be your issue since you have dropped events in your
> blktraces. You need to eliminate any dropped events - either log to
> tmpfs or send the traces over the network, that would likely do it.
>
> If that doesn't solve it for you, please boil this down to a smaller
> test case. Start with one device. Does that work? Up the complexity
> until you see an issue, then I can likely help you get this fixed if I
> get the problematic trace.

Can you try current -git? I made some improvements/fixes to the multiple 
device handling.

-- 
Jens Axboe


