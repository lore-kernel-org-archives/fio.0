Return-Path: <egouriou@google.com>
MIME-Version: 1.0
In-Reply-To: <4DF7BD7D.3040708@kernel.dk>
References: <1308080427-31011-1-git-send-email-egouriou@google.com>
	<4DF7BD7D.3040708@kernel.dk>
Date: Tue, 14 Jun 2011 18:08:18 -0700
Message-ID: <BANLkTikwoK4uwO79Lyxrt_cy152ZRDcXyQO5SuOS7ijdaKz_sQ@mail.gmail.com>
Subject: Re: [PATCH] Add fallocate_keep_size option and functionality
From: Eric Gouriou <egouriou@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Daniel Ehrenberg <dehrenberg@google.com>
List-ID: <fio@vger.kernel.org>

Hi Jens,

On Tue, Jun 14, 2011 at 12:58 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-06-14 21:40, Eric Gouriou wrote:
>> Linux offers fallocate() and the FALLOC_FL_KEEP_SIZE option as
>> an alternative to posix_fallocate(). When FALLOC_FL_KEEP_SIZE is
>> specified for an falloc request going beyond the end of the file,
>> the requested blocks get preallocated without changing the apparent
>> size of the file. This is is a commonly recommended use of fallocate()
>> for workloads performing append writes.
>>
>> On systems where FALLOC_FL_KEEP_SIZE is available (i.e., Linux at this
>> time), this patch add a fallocate_keep_size option, which is off by
>> default. When *both* the options fallocate and fallocate_keep_size are
>> set, then fallocate() will be used with FALLOC_FL_KEEP_SIZE set,
>> instead of the default posix_fallocate().
>>
>> Signed-off-by: Eric Gouriou <egouriou@google.com>
>> ---
>> I tried to follow the existing style and practices. I am wondering
>> whether introducing 'fallocate_keep_size' is the best way, or whether
>> I should have changed the existing 'fallocate' option from a boolean
>> option to a string option. Let me know what you think.
>
> Perhaps we could use just the one option, and have 0/1 retain they
> meaning and add "keep" or something as the new variant.

Certainly. Please check my assumptions: the suggestion is to change
"fallocate" to use FIO_OPT_STR with .posval values of "0", "1",
and "keep".

If so, do you suggest that all options should be presented to all platforms=
,
or have "keep" only show up when FIO_HAVE_LINUX_FALLOCATE is present?
- if I always have "keep" available, what do you suggest we do when
 FIO_HAVE_LINUX_FALLOCATE is not defined? Fail in a verify_xxx()
 callback?
- if we only have "keep" available on when FIO_HAVE_LINUX_FALLOCATE
  is defined, then other platforms have, in effect, a boolean flag which do=
es
  not behave as the other boolean flags when given invalid values.

There is nothing major here, I'm mostly looking for stylistic/idiom prefere=
nces.

> Other than that, just one comment:
>
>> diff --git a/helpers.c b/helpers.c
>> index 377dd02..0da2fd7 100644
>> --- a/helpers.c
>> +++ b/helpers.c
>> @@ -14,6 +14,11 @@ int __weak posix_fallocate(int fd, off_t offset, off_=
t len)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 return 0;
>> =C2=A0}
>> +
>> +int __weak fallocate(int fd, int mode, off_t offset, off_t len)
>> +{
>> + =C2=A0 =C2=A0 return 0;
>> +}
>> =C2=A0#endif
>
> Say we have posix_fallocate() and not fallocate(), have it call
> posix_fallocate()?

Thanks for highlighting this part of the code. While adding this, I was uns=
ure
about whether it was at all useful. Currently the only use of the linux-spe=
cific
fallocate() is with the FALLOC_FL_KEEP_SIZE flag, Since this flag is define=
d
in the same header file that defines fallocate(), I'm not really
seeing the point
of the weak definition. I mostly followed what had been done for
posix_fallocate().

I'm unclear whether there is a point in shimming fallocate() calls towards
posix_fallocate(). Currently the only use of fallocate() has
significant semantic
differences compared to what posix_fallocate() offers. Would we want to war=
n
users if the shimming is ever used? (if so, what's the custom?)

The shimming would also involve writing to errno as posix_fallocate() follo=
ws
the more recent POSIX convention of returning error values directly while
fallocate() follows the Unix tradition of returning 0/-1 and error values i=
n
errno.

I'm open to add such logic. I'd appreciate further feedback regarding its
appropriateness and the wisdom of even defining this weak version.

 Thanks - Eric

>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>

