Return-Path: <tirea@google.com>
MIME-Version: 1.0
In-Reply-To: <4EB08371.2030904@kernel.dk>
References: <CAAUT-yMDPw4x-g=6Ag0UQGHGPgbiqctim1OiP8WuuiYr3-PjqQ@mail.gmail.com>
 <4EB08371.2030904@kernel.dk>
From: Steven Lang <tirea@google.com>
Date: Tue, 1 Nov 2011 17:27:43 -0700
Message-ID: <CAAUT-yNFcw6+8L911TYcSEED==QToxTbJLXZ8pA7Kuv6A=LqZw@mail.gmail.com>
Subject: Re: An alternative way to handle IO engine options
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Alright I'll go ahead with finishing it.

For the issue of global options...  There are two possibilities I have
in mind.  The first is to limit it to just an ioengine that is
specified, and the options for that ioengine are the only ioengine
options that are allowed.  That would probably be "good enough" for
most cases.  However, for a load which used two different IO engines,
it would limit the global options to only one of the ioengines.

The second option would be to have a way to specify options for
different ioengines within the global section, then keep a copy of the
config struct for each that is specified to use as a template.

What I don't like about the second option is that the conf syntax for
it might be somewhat messy.

A third option would be to just parse the global options with respect
to every known ioengine, or even just store the raw config values and
parse them with each job.

I'm not sure which is the best option; however unless there's some
justification for doing otherwise I may just go with the first
(simplest) for now, and if it becomes an issue the rest can be patched
in later.

On Tue, Nov 1, 2011 at 4:40 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-11-01 21:16, Steven Lang wrote:
>> This isn't quite ready to be a patch yet, but I wanted to get some
>> feedback before I put in time polishing it to patch level.
>>
>> The idea has been bouncing around in my head that some IO engines have
>> unique parameters. =A0However, fio has no way to make engine specific
>> parameters, aside from doing special cases in the options parsing, or
>> using some option in a convoluted way it wasn't intended for. =A0For
>> example, the libaio:userspace_reap option, and the net IO engine
>> turning the filename into a series of fields you have to know the
>> correct syntax and order for.
>>
>> Neither of these options seem ideal to me; the first requires special
>> casing and limits it to a single option, the second results in
>> potentially cryptic requirements.
>>
>> At the same time, though, there is only one place in the config
>> parsing/management which assumes there is a single config
>> (options_mem_dupe) - everything else is told what the options are and
>> treats the data as a mostly opaque block of memory, even though it is
>> just a single global variable and a fixed config structure. =A0This
>> seems like it is just begging to be re-used within the IO engine
>> framework to parse custom options. =A0So that is what I have done. =A0Fo=
r
>> now in this code just the libaio userspace_reap option has been
>> changed, but it would make sense to apply the same treatment to the
>> net IO engine.
>>
>> The basic idea is it looks through the config section and makes note
>> of any unrecognized options, rather than reporting them right away.
>> Then it loads the requested IO engine and runs through the unknown
>> options against the IO engine config. =A0At that point, any unknown
>> options are reported.
>>
>> There are a few things not finished yet...
>> 1. Right now it is conf parsing only; command line parsing never sees
>> the new options (But I have a plan, with the restriction that the IO
>> engine must be named before its options can be used)
>> 2. Documentation for the userspace_reap option will need to be changed.
>> 3. There's currently no way to handle IO engine options in the [global] =
section.
>>
>> Do you see any problems with this approach to handling options that
>> are specific to a single IO engine?
>
> I like this a lot, I've been thinking about private options in the past
> and things like userspace_reap is indeed just a nasty hack. It would be
> very nice to handle this in a more generic fashion. We would need to
> solve the generic vs global name space problem though, otherwise that's
> just a problem waiting to happen. Apart from that, I would not have any
> problems merging this feature.
>
> --
> Jens Axboe
>
>

