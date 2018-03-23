Return-Path: <axboe@kernel.dk>
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: valgrind spews
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CALjAwxiC_OVeVYjq=dV1pNM2iTvK0NzVKVe=3L=M=Rz-wt+qYw@mail.gmail.com>
Date: Fri, 23 Mar 2018 16:53:54 -0600
Content-Transfer-Encoding: quoted-printable
Message-Id: <15125202-A23D-4862-9C5F-FFE58A78E027@kernel.dk>
References: <a7527854-7ed3-a074-278e-e75f75cec4e7@kernel.dk> <CALjAwxgaVddxmgzkM6S7d6SP0FTdBT9y6QeO58L870qxBYDqAg@mail.gmail.com> <ed74b20d-cd3b-2b0a-89d1-188be58a5dae@kernel.dk> <1521738727.2637.14.camel@sandisk.com> <3e6568da-0dfe-7d4a-138d-f04e43a3dd7b@kernel.dk> <1521739678.2637.16.camel@wdc.com> <baec1170-03fc-7b43-85e6-8e80f2d11006@kernel.dk> <CALjAwxhOT1NJX556Y19_mMoY53sOf6V=-Q79FVfa8eX39vBJew@mail.gmail.com> <afb83e62-4b15-358f-c54e-012a80e7aa95@kernel.dk> <1521818158.2535.0.camel@wdc.com> <CALjAwxiWMRznn==MR=NGRDVsa1LtiR1EWthKgXzsO1MBADYzOg@mail.gmail.com> <1521841789.2535.21.camel@wdc.com> <CALjAwxiC_OVeVYjq=dV1pNM2iTvK0NzVKVe=3L=M=Rz-wt+qYw@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


> On Mar 23, 2018, at 4:18 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>=20
>> On 23 March 2018 at 21:49, Bart Van Assche <Bart.VanAssche@wdc.com> wrote=
:
>>> On Fri, 2018-03-23 at 21:43 +0000, Sitsofe Wheeler wrote:
>>>> On 23 March 2018 at 15:15, Bart Van Assche <Bart.VanAssche@wdc.com> wro=
te:
>>>>> On Fri, 2018-03-23 at 08:49 -0600, Jens Axboe wrote:
>>>>> Right, this is identical to what I reported. I get tons of these with
>>>>> the patch, not without.
>>>>=20
>>>> Since I can reproduce this I will have a look at what is going on.
>>>=20
>>> I wonder if the manner that fio allocates redzones is incompatible
>>> with valgrind's due to fio's redzone's potentially being smaller than
>>> the size of a pointer and the pre-redzone being partially inside the
>>> header structure. I'm attaching a patch I made but it still seems to
>>> generate valgrind warnings that aren't there when falling back to
>>> malloc/free without pools...
>>=20
>> Hello Sitsofe,
>>=20
>> Have you enabled github's feature to send an e-mail every time a pull req=
uest
>> is created or a comment is added? This issue should have been resolved by=
 a
>> pull request I submitted this morning. That pull request has been accepte=
d by
>> Jens.
>=20
> Ah thanks Bart - I see it now over on
> https://github.com/axboe/fio/pull/567 (my GitHub email goes to a
> different email account that I check less frequently). Kind of a shame
> valgrind can't track malloc/free across a fork but also
> understandable. Anyone up for enabling thread mode for fio's --server
> ? ;-)

That would actually be awesome for other reasons, like enabling duo server s=
upport on platforms like Windows that don=E2=80=99t support fork().

Not easy, but highly encouraged :-)


