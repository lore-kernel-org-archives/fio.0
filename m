Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v1 3/3] fio: suggest installing engine package when
 missing
References: <cover.1592981060.git.ykorman@gmail.com>
 <678d10332ad5edb5d076d0fe94a833fe595a3020.1592981060.git.ykorman@gmail.com>
 <x49zh8l28t1.fsf@segfault.boston.devel.redhat.com>
 <CAOdGBnGBcAEUEJziix6ysoTs7c4=TrBBdxEq9ELRARKcDWK+5g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7bc37a01-2cd6-fc05-69bc-606aaf524e65@kernel.dk>
Date: Tue, 30 Jun 2020 13:41:08 -0600
MIME-Version: 1.0
In-Reply-To: <CAOdGBnGBcAEUEJziix6ysoTs7c4=TrBBdxEq9ELRARKcDWK+5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Yigal Korman <ykorman@gmail.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 6/30/20 1:29 PM, Yigal Korman wrote:
> On Mon, Jun 29, 2020 at 6:25 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> Yigal Korman <ykorman@gmail.com> writes:
>>
>>> Signed-off-by: Yigal Korman <ykorman@gmail.com>
>>> ---
>>>  ioengines.c | 8 +++++++-
>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/ioengines.c b/ioengines.c
>>> index 78262bc1..20224e59 100644
>>> --- a/ioengines.c
>>> +++ b/ioengines.c
>>> @@ -79,10 +79,16 @@ static struct ioengine_ops *find_ioengine(const char *name)
>>>  static void *dlopen_external(struct thread_data *td, const char *engine)
>>>  {
>>>       char engine_path[PATH_MAX];
>>> +     void *dlhandle;
>>>
>>>       sprintf(engine_path, "%s/lib%s.so", FIO_EXT_ENG_DIR, engine);
>>>
>>> -     return dlopen(engine_path, RTLD_LAZY);
>>> +     dlhandle = dlopen(engine_path, RTLD_LAZY);
>>> +     if (!dlhandle)
>>> +             log_info("Engine not available; Install the fio-engine-%s package\n",
>>> +                      engine);
>>> +
>>> +     return dlhandle;
>>>  }
>>>  #else
>>>  #define dlopen_external(td, engine) (NULL)
>>
>> This assumes fio is part of a package, and that's not always (often?)
>> the case.  It may be that the engine simply wasn't built.
> 
> I agree.
> This patch is more of a showcase of how to help package maintainers
> transition users to the new packaging model.
> I will drop it from the next patchset version.
> This patch might have made more sense if I had implemented a whitelist
> of engines that were compiled dynamically.

I'd say keep it, but make it a bit more generic so it applies to self
built installs too.

"IO Engine %s not available. Either the engine name is invalid, or you need
 to Install the fio-engine-%s package, or build fio with the necessary
 libraries available."

Something like that.

-- 
Jens Axboe


