Return-Path: <axboe@kernel.dk>
Message-ID: <543E8BFA.7090207@kernel.dk>
Date: Wed, 15 Oct 2014 09:00:10 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: BUG - Cannot build fio on redhat 5
References: <CAMA-6iaCvppOLvBOP6K2+Gt-BEo5x_m_BXvq8xs8K8ezgt132w@mail.gmail.com> <543D907B.3080005@kernel.dk> <CADzpL0T6cQ=pWr4iM=0JoV_e-3wfO65s-PgYXC-YPr1mYvzuFQ@mail.gmail.com> <543E84BD.9040303@kernel.dk> <CAGpXXZJk2YJQug6pmA0rHY4xAhhgjFxFxStPWB5tF+-bKrEdiQ@mail.gmail.com>
In-Reply-To: <CAGpXXZJk2YJQug6pmA0rHY4xAhhgjFxFxStPWB5tF+-bKrEdiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Stephen Cameron <stephenmcameron@gmail.com>, Tim Delaney <2timdelaney@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/15/2014 08:56 AM, Greg Freemyer wrote:
> On Wed, Oct 15, 2014 at 10:29 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/14/2014 10:24 PM, Stephen Cameron wrote:
>>> Been traveling all day, so only just now saw this thread... I can take
>>> a look tomorrow, if you haven't already solved it.  I don't have
>>> access to any rhel5 systems though.
>>
>> I'm doing a kvm install right now to test it, so unless you hear
>> otherwise, consider it taken care of.
>>
>> --
>> Jens Axboe
> 
> If you don't know the opensuse build service (OBS) will let you build
> for a number of distros.  The only issue is you need a specfile or deb
> control file appropriate to the distro.  ie. typically the opensuse
> specfile will not work with RedHat and vice versa.  Debian and Ubuntu
> don't use specfiles at all.
> 
> For release build testing it might be useful to maintain a fio package
> on OBS that builds for various distros and do a test build prior to
> each release.
> 
> Anyone can create an account at build.opensuse.org and leverage the build farm.
> 
> Here's the current list of supported distros:
> 
>> osc dists
> distribution              project                   repository
>        reponame
> ------------              -------                   ----------
>        --------
> openSUSE Factory          openSUSE:Factory          snapshot
>        openSUSE_Factory
> openSUSE 13.2             openSUSE:13.2             standard
>        openSUSE_13.2
> openSUSE 13.1             openSUSE:13.1             standard
>        openSUSE_13.1
> openSUSE 12.3             openSUSE:12.3             standard
>        openSUSE_12.3
> openSUSE 12.2             openSUSE:12.2             standard
>        openSUSE_12.2
> openSUSE Factory ARM      openSUSE:Factory:ARM      standard
>        openSUSE_Factory_ARM
> openSUSE Tumbleweed       openSUSE:Tumbleweed       standard
>        openSUSE_Tumbleweed
> SUSE SLE-11 SP 3          SUSE:SLE-11:SP3           standard
>        SLE_11_SP3
> SUSE SLE-11 SP 2          SUSE:SLE-11:SP2           standard
>        SLE_11_SP2
> SUSE SLE-10               SUSE:SLE-10:SDK           standard
>        SLE_10_SDK
> Arch Core                 Arch:Core                 standard
>        Arch_Core
> Arch Extra                Arch:Extra                standard
>        Arch_Extra
> Debian 7.0                Debian:7.0                standard
>        Debian_7.0
> Debian 6.0                Debian:6.0                standard
>        Debian_6.0
> Fedora 20                 Fedora:20                 standard
>        Fedora_20
> Fedora 19                 Fedora:19                 standard
>        Fedora_19
> Fedora 18                 Fedora:18                 standard
>        Fedora_18
> ScientificLinux 7         ScientificLinux:7         standard
>        ScientificLinux_7
> ScientificLinux 6         ScientificLinux:6         standard
>        ScientificLinux_6
> RedHat RHEL-7             RedHat:RHEL-7             standard
>        RHEL_7
> RedHat RHEL-6             RedHat:RHEL-6             standard
>        RHEL_6
> RedHat RHEL-5             RedHat:RHEL-5             standard
>        RHEL_5
> RedHat RHEL-4             RedHat:RHEL-4             standard
>        RHEL_4
> CentOS CentOS-7           CentOS:CentOS-7           standard
>        CentOS_7
> CentOS CentOS-6           CentOS:CentOS-6           standard
>        CentOS_6
> CentOS CentOS-5           CentOS:CentOS-5           standard
>        CentOS_5
> Ubuntu 14.04              Ubuntu:14.04              standard
>        xUbuntu_14.04
> Ubuntu 13.10              Ubuntu:13.10              standard
>        xUbuntu_13.10
> Ubuntu 12.10              Ubuntu:12.10              standard
>        xUbuntu_12.10
> Ubuntu 12.04              Ubuntu:12.04              standard
>        xUbuntu_12.04
> Ubuntu 11.10              Ubuntu:11.10              standard
>        xUbuntu_11.10
> Ubuntu 10.04              Ubuntu:10.04              standard
>        xUbuntu_10.04
> Univention UCS 3.2        Univention:3.2            standard
>        Univention_3.2
> Univention UCS 3.1        Univention:3.1            standard
>        Univention_3.1
> 
> 
> fyi: I just attempted a RedHat test build of fio 2.1.13 and it failed
> with the standard openSUSE specfile:
> 
> https://build.opensuse.org/package/show/home:gregfreemyer:Tools-for-forensic-boot-cd/fio
> 
> I suspect it would be relatively easy to make the specfile both
> openSUSE and RedHat compatible if there is any value in it.
> 
> It typically just requires adding some %if logic to the specfile to
> handle the different distros.

That would be absolutely wonderful. I do some of these manually before
release, especially if changes have gone in that could affect build on
various distros. But would be great to have it automated. Unfortunately
I'm not a rpmfile/deb wizard, and I lack the motivation (and time) to
take the time to do this. So if anyone would like to step up and help
out with this, that would be awesome.

Currently the deb and rpm spec files are not included with fio, but they
do exist in the debian (ish) and rpm based packages that people roll for
distributions. So hopefully it should not be too much work. It might
even be a good idea to include them with fio, especially if we're going
to automate some of this building/testing.

-- 
Jens Axboe


