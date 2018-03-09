Return-Path: <akoundal@gmail.com>
MIME-Version: 1.0
In-Reply-To: <f23126d3-5676-4cb7-74f7-a1ff7f005dd5@kernel.dk>
References: <CAKwzdDrG3vgzMzttpZm4HgbziXUNsXiOgNP_PAty+KRasQ7szg@mail.gmail.com>
 <CAKwzdDpwvgmWtCssGYNDv7BLgoPe56SqRCtFf_B0P1i9oR4fOw@mail.gmail.com>
 <CAKwzdDqbdDJqK-TKEss5H5+e0hiFns2Tv6Rj6hqHvxN7QBXPZA@mail.gmail.com>
 <CAKwzdDowpJ3FkUgySFJM1nE3YKP5Ru7c76KtNFBOA2wgHRWy+g@mail.gmail.com>
 <CALjAwxht9kUnEZPnjgE8nrFB6GhtJAUNX0JLobYw9ffTfYRB+g@mail.gmail.com>
 <CAKwzdDqOCQiQCFTYPd_tz9=DwvW+qNc=rTkW4Mu8yY8uL71fdg@mail.gmail.com>
 <CAKwzdDoFAARSxVQYLzBqqqeAJvGe4dkVjwsipP6zkSPc1rwyTw@mail.gmail.com>
 <CALjAwxiXQYQR6CVJjs6AukG=PGTqit3THSxCA3RSUFo6TbRCEA@mail.gmail.com>
 <CAKwzdDr2z-Z7YQK0GpSX_syvFDtdZ_Px7k5Fd1G0eaE12cy7_A@mail.gmail.com>
 <CALjAwxgRN3i+ZQq92yJa9NMfdfAxuBrxqHOQTbn_9L7SoFCYsQ@mail.gmail.com>
 <CAKwzdDqj81MK7i63idBLUnm22pXO9bK_2P5b-o7=JOOvKjcKYw@mail.gmail.com>
 <CALjAwxia6L1SfuaZA4Vr_XrSJ9z7F6A1Xe=3p2zML0ADGaUstQ@mail.gmail.com>
 <12a5a0b9-3ad2-f5ab-7dd3-296ba0356f4d@kernel.dk> <CAKwzdDo=i3s1aBuxK0ionKV52uvLs86Ybcm77tsONtNNcx5+Gg@mail.gmail.com>
 <f23126d3-5676-4cb7-74f7-a1ff7f005dd5@kernel.dk>
From: abhishek koundal <akoundal@gmail.com>
Date: Fri, 9 Mar 2018 12:34:35 -0800
Message-ID: <CAKwzdDo-woBpxx0heJa-Aa4YQJOgAfT4Cn+xTCV-pygpTsyT8Q@mail.gmail.com>
Subject: Re: FIO size parameter feedback
Content-Type: multipart/alternative; boundary="001a114450347eee76056700b8d0"
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--001a114450347eee76056700b8d0
Content-Type: text/plain; charset="UTF-8"

Cool, thanks!

On Mar 9, 2018 12:32 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

> Code change, I don't think it makes any sense that 100% behaves
> differently than not setting it at all, since that's equivalent
> to 100%.
>
> Already made the change...
>
> On 3/9/18 1:08 PM, abhishek koundal wrote:
> > Are we suggesting the document wording change or actual code change?
> >
> > On Fri, Mar 9, 2018 at 11:54 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >> I think we should just skip the alignment/adjustment if
> >> size_percent is equal to 100. It doesn't make sense to
> >> change it for full size. I'd rather have consistent
> >> behavior here, and I think the risk is pretty low in
> >> this case.
> >>
> >> On 3/7/18 1:19 PM, Sitsofe Wheeler wrote:
> >>> I'd argue that by now someone will have started depending on the
> >>> rounding behaviour of a percentage size and someone else will be
> >>> depending on the non-rounding behaviour when its specified without
> >>> percentages so you'd need a strong reason to change. However
> >>> documenting this quirk would be helpful...
> >>>
> >>> On 7 March 2018 at 19:07, abhishek koundal <akoundal@gmail.com> wrote:
> >>>> So do we say its how the tool has to behave? (surely with added
> documentation)
> >>>>
> >>>> On Wed, Mar 7, 2018 at 10:38 AM, Sitsofe Wheeler <sitsofe@gmail.com>
> wrote:
> >>>>> I'd say it's something that could be better documented (size as
> >>>>> percentage rounds to the minimum blocksize) in the same way it's
> >>>>> already documented for offset percentages. The problem is if size
> >>>>> didn't do the rounding of percentages things would get tricky when
> you
> >>>>> start trying to cut disks up using offset and size (think offset=0%
> >>>>> size=25% then offset=25% size=25%). Plus you don't really want to do
> >>>>> rounding when the user specifies an exact amount/doesn't set anything
> >>>>> at all because you want to assume the user knows what they are
> >>>>> doing...
> >>>
> >>
> >>
> >> --
> >> Jens Axboe
> >>
> >
> >
> >
>
>
> --
> Jens Axboe
>
>

--001a114450347eee76056700b8d0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Cool, thanks!=C2=A0</div><div class=3D"gmail_extra"><br><=
div class=3D"gmail_quote">On Mar 9, 2018 12:32 PM, &quot;Jens Axboe&quot; &=
lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br typ=
e=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex">Code change, I don&#39;t t=
hink it makes any sense that 100% behaves<br>
differently than not setting it at all, since that&#39;s equivalent<br>
to 100%.<br>
<br>
Already made the change...<br>
<br>
On 3/9/18 1:08 PM, abhishek koundal wrote:<br>
&gt; Are we suggesting the document wording change or actual code change?<b=
r>
&gt;<br>
&gt; On Fri, Mar 9, 2018 at 11:54 AM, Jens Axboe &lt;<a href=3D"mailto:axbo=
e@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br>
&gt;&gt; I think we should just skip the alignment/adjustment if<br>
&gt;&gt; size_percent is equal to 100. It doesn&#39;t make sense to<br>
&gt;&gt; change it for full size. I&#39;d rather have consistent<br>
&gt;&gt; behavior here, and I think the risk is pretty low in<br>
&gt;&gt; this case.<br>
&gt;&gt;<br>
&gt;&gt; On 3/7/18 1:19 PM, Sitsofe Wheeler wrote:<br>
&gt;&gt;&gt; I&#39;d argue that by now someone will have started depending =
on the<br>
&gt;&gt;&gt; rounding behaviour of a percentage size and someone else will =
be<br>
&gt;&gt;&gt; depending on the non-rounding behaviour when its specified wit=
hout<br>
&gt;&gt;&gt; percentages so you&#39;d need a strong reason to change. Howev=
er<br>
&gt;&gt;&gt; documenting this quirk would be helpful...<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; On 7 March 2018 at 19:07, abhishek koundal &lt;<a href=3D"mail=
to:akoundal@gmail.com">akoundal@gmail.com</a>&gt; wrote:<br>
&gt;&gt;&gt;&gt; So do we say its how the tool has to behave? (surely with =
added documentation)<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; On Wed, Mar 7, 2018 at 10:38 AM, Sitsofe Wheeler &lt;<a hr=
ef=3D"mailto:sitsofe@gmail.com">sitsofe@gmail.com</a>&gt; wrote:<br>
&gt;&gt;&gt;&gt;&gt; I&#39;d say it&#39;s something that could be better do=
cumented (size as<br>
&gt;&gt;&gt;&gt;&gt; percentage rounds to the minimum blocksize) in the sam=
e way it&#39;s<br>
&gt;&gt;&gt;&gt;&gt; already documented for offset percentages. The problem=
 is if size<br>
&gt;&gt;&gt;&gt;&gt; didn&#39;t do the rounding of percentages things would=
 get tricky when you<br>
&gt;&gt;&gt;&gt;&gt; start trying to cut disks up using offset and size (th=
ink offset=3D0%<br>
&gt;&gt;&gt;&gt;&gt; size=3D25% then offset=3D25% size=3D25%). Plus you don=
&#39;t really want to do<br>
&gt;&gt;&gt;&gt;&gt; rounding when the user specifies an exact amount/doesn=
&#39;t set anything<br>
&gt;&gt;&gt;&gt;&gt; at all because you want to assume the user knows what =
they are<br>
&gt;&gt;&gt;&gt;&gt; doing...<br>
&gt;&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; --<br>
&gt;&gt; Jens Axboe<br>
&gt;&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
<br>
<br>
--<br>
Jens Axboe<br>
<br>
</blockquote></div></div>

--001a114450347eee76056700b8d0--

