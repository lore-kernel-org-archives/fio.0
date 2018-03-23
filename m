Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1521841789.2535.21.camel@wdc.com>
References: <a7527854-7ed3-a074-278e-e75f75cec4e7@kernel.dk>
 <CALjAwxgaVddxmgzkM6S7d6SP0FTdBT9y6QeO58L870qxBYDqAg@mail.gmail.com>
 <ed74b20d-cd3b-2b0a-89d1-188be58a5dae@kernel.dk> <1521738727.2637.14.camel@sandisk.com>
 <3e6568da-0dfe-7d4a-138d-f04e43a3dd7b@kernel.dk> <1521739678.2637.16.camel@wdc.com>
 <baec1170-03fc-7b43-85e6-8e80f2d11006@kernel.dk> <CALjAwxhOT1NJX556Y19_mMoY53sOf6V=-Q79FVfa8eX39vBJew@mail.gmail.com>
 <afb83e62-4b15-358f-c54e-012a80e7aa95@kernel.dk> <1521818158.2535.0.camel@wdc.com>
 <CALjAwxiWMRznn==MR=NGRDVsa1LtiR1EWthKgXzsO1MBADYzOg@mail.gmail.com> <1521841789.2535.21.camel@wdc.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 23 Mar 2018 22:18:14 +0000
Message-ID: <CALjAwxiC_OVeVYjq=dV1pNM2iTvK0NzVKVe=3L=M=Rz-wt+qYw@mail.gmail.com>
Subject: Re: valgrind spews
Content-Type: text/plain; charset="UTF-8"
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 23 March 2018 at 21:49, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Fri, 2018-03-23 at 21:43 +0000, Sitsofe Wheeler wrote:
>> On 23 March 2018 at 15:15, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>> > On Fri, 2018-03-23 at 08:49 -0600, Jens Axboe wrote:
>> > > Right, this is identical to what I reported. I get tons of these with
>> > > the patch, not without.
>> >
>> > Since I can reproduce this I will have a look at what is going on.
>>
>> I wonder if the manner that fio allocates redzones is incompatible
>> with valgrind's due to fio's redzone's potentially being smaller than
>> the size of a pointer and the pre-redzone being partially inside the
>> header structure. I'm attaching a patch I made but it still seems to
>> generate valgrind warnings that aren't there when falling back to
>> malloc/free without pools...
>
> Hello Sitsofe,
>
> Have you enabled github's feature to send an e-mail every time a pull request
> is created or a comment is added? This issue should have been resolved by a
> pull request I submitted this morning. That pull request has been accepted by
> Jens.

Ah thanks Bart - I see it now over on
https://github.com/axboe/fio/pull/567 (my GitHub email goes to a
different email account that I check less frequently). Kind of a shame
valgrind can't track malloc/free across a fork but also
understandable. Anyone up for enabling thread mode for fio's --server
? ;-)

-- 
Sitsofe | http://sucs.org/~sits/

