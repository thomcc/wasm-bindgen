/* -*- Mode: IDL; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * The origin of this IDL file is:
 * http://www.whatwg.org/specs/web-apps/current-work/
 * https://dvcs.w3.org/hg/editing/raw-file/tip/editing.html
 * https://dvcs.w3.org/hg/IndexedDB/raw-file/tip/Overview.html
 * http://dev.w3.org/csswg/cssom/
 * http://dev.w3.org/csswg/cssom-view/
 * https://dvcs.w3.org/hg/webperf/raw-file/tip/specs/RequestAnimationFrame/Overview.html
 * https://dvcs.w3.org/hg/webperf/raw-file/tip/specs/NavigationTiming/Overview.html
 * https://dvcs.w3.org/hg/webcrypto-api/raw-file/tip/spec/Overview.html
 * http://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html
 * https://w3c.github.io/webappsec-secure-contexts/#monkey-patching-global-object
 * https://w3c.github.io/requestidlecallback/
 * https://drafts.css-houdini.org/css-paint-api-1/#dom-window-paintworklet
 */

// invalid widl
// interface ApplicationCache;
// interface IID;
// interface nsIBrowserDOMWindow;
// interface XULControllers;

// http://www.whatwg.org/specs/web-apps/current-work/
[Global=Window,
 Exposed=Window,
 LegacyUnenumerableNamedProperties]
/*sealed*/ interface Window : EventTarget {
  // the current browsing context
  [Unforgeable, Constant, StoreInSlot,
   CrossOriginReadable] readonly attribute Window window;
  [Replaceable, Constant, StoreInSlot,
   CrossOriginReadable] readonly attribute Window self;
  [Unforgeable, StoreInSlot, Pure] readonly attribute Document? document;
  [Throws] attribute DOMString name;
  [PutForwards=href, Unforgeable, BinaryName="getLocation",
   CrossOriginReadable, CrossOriginWritable] readonly attribute Location location;
  [Throws] readonly attribute History history;
  [Func="CustomElementRegistry::IsCustomElementEnabled"]
  readonly attribute CustomElementRegistry customElements;
  [Replaceable, Throws] readonly attribute BarProp locationbar;
  [Replaceable, Throws] readonly attribute BarProp menubar;
  [Replaceable, Throws] readonly attribute BarProp personalbar;
  [Replaceable, Throws] readonly attribute BarProp scrollbars;
  [Replaceable, Throws] readonly attribute BarProp statusbar;
  [Replaceable, Throws] readonly attribute BarProp toolbar;
  [Throws] attribute DOMString status;
  [Throws, CrossOriginCallable] void close();
  [Throws, CrossOriginReadable] readonly attribute boolean closed;
  [Throws] void stop();
  [Throws, CrossOriginCallable] void focus();
  [Throws, CrossOriginCallable] void blur();
  [Replaceable] readonly attribute any event;

  // other browsing contexts
  [Replaceable, Throws, CrossOriginReadable] readonly attribute WindowProxy frames;
  [Replaceable, CrossOriginReadable] readonly attribute unsigned long length;
  //[Unforgeable, Throws, CrossOriginReadable] readonly attribute WindowProxy top;
  [Unforgeable, Throws, CrossOriginReadable] readonly attribute WindowProxy? top;
  [Throws, CrossOriginReadable] attribute any opener;
  //[Throws] readonly attribute WindowProxy parent;
  [Replaceable, Throws, CrossOriginReadable] readonly attribute WindowProxy? parent;
  [Throws, NeedsSubjectPrincipal] readonly attribute Element? frameElement;
  //[Throws] WindowProxy? open(optional USVString url = "about:blank", optional DOMString target = "_blank", [TreatNullAs=EmptyString] optional DOMString features = "");
  [Throws] WindowProxy? open(optional DOMString url = "", optional DOMString target = "", [TreatNullAs=EmptyString] optional DOMString features = "");
  getter object (DOMString name);

  // the user agent
  readonly attribute Navigator navigator;
//#ifdef HAVE_SIDEBAR
  [Replaceable, Throws] readonly attribute External external;
//#endif
  [Throws, Pref="browser.cache.offline.enable", Func="nsGlobalWindowInner::OfflineCacheAllowedForContext"] readonly attribute ApplicationCache applicationCache;

  // user prompts
  [Throws, NeedsSubjectPrincipal] void alert();
  [Throws, NeedsSubjectPrincipal] void alert(DOMString message);
  [Throws, NeedsSubjectPrincipal] boolean confirm(optional DOMString message = "");
  [Throws, NeedsSubjectPrincipal] DOMString? prompt(optional DOMString message = "", optional DOMString default = "");
  [Throws, Func="nsGlobalWindowInner::IsWindowPrintEnabled"]
  void print();

  [Throws, CrossOriginCallable, NeedsSubjectPrincipal]
  void postMessage(any message, DOMString targetOrigin, optional sequence<object> transfer = []);

  // also has obsolete members
};
Window implements GlobalEventHandlers;
Window implements WindowEventHandlers;

// https://www.w3.org/TR/appmanifest/#onappinstalled-attribute
partial interface Window {
  [Pref="dom.manifest.onappinstalled"]
  attribute EventHandler onappinstalled;
};

// http://www.whatwg.org/specs/web-apps/current-work/
[NoInterfaceObject]
interface WindowSessionStorage {
  //[Throws] readonly attribute Storage sessionStorage;
  [Throws] readonly attribute Storage? sessionStorage;
};
Window implements WindowSessionStorage;

// http://www.whatwg.org/specs/web-apps/current-work/
[NoInterfaceObject]
interface WindowLocalStorage {
  [Throws] readonly attribute Storage? localStorage;
};
Window implements WindowLocalStorage;

// http://www.whatwg.org/specs/web-apps/current-work/
partial interface Window {
  void captureEvents();
  void releaseEvents();
};

// https://dvcs.w3.org/hg/editing/raw-file/tip/editing.html
partial interface Window {
  //[Throws] Selection getSelection();
  [Throws] Selection? getSelection();
};

// http://dev.w3.org/csswg/cssom/
partial interface Window {
  //[NewObject, Throws] CSSStyleDeclaration getComputedStyle(Element elt, optional DOMString pseudoElt = "");
  [NewObject, Throws] CSSStyleDeclaration? getComputedStyle(Element elt, optional DOMString pseudoElt = "");
};

// http://dev.w3.org/csswg/cssom-view/
enum ScrollBehavior { "auto", "instant", "smooth" };

dictionary ScrollOptions {
  ScrollBehavior behavior = "auto";
};

dictionary ScrollToOptions : ScrollOptions {
  unrestricted double left;
  unrestricted double top;
};

partial interface Window {
  //[Throws, NewObject, NeedsCallerType] MediaQueryList matchMedia(DOMString query);
  [Throws, NewObject, NeedsCallerType] MediaQueryList? matchMedia(DOMString query);
  // Per spec, screen is SameObject, but we don't actually guarantee that given
  // nsGlobalWindow::Cleanup.  :(
  //[SameObject, Replaceable, Throws] readonly attribute Screen screen;
  [Replaceable, Throws] readonly attribute Screen screen;

  // browsing context
  //[Throws] void moveTo(double x, double y);
  //[Throws] void moveBy(double x, double y);
  //[Throws] void resizeTo(double x, double y);
  //[Throws] void resizeBy(double x, double y);
  [Throws, NeedsCallerType] void moveTo(long x, long y);
  [Throws, NeedsCallerType] void moveBy(long x, long y);
  [Throws, NeedsCallerType] void resizeTo(long x, long y);
  [Throws, NeedsCallerType] void resizeBy(long x, long y);

  // viewport
  // These are writable because we allow chrome to write them.  And they need
  // to use 'any' as the type, because non-chrome writing them needs to act
  // like a [Replaceable] attribute would, which needs the original JS value.
  //[Replaceable, Throws] readonly attribute double innerWidth;
  //[Replaceable, Throws] readonly attribute double innerHeight;
  [Throws, NeedsCallerType] attribute any innerWidth;
  [Throws, NeedsCallerType] attribute any innerHeight;

  // viewport scrolling
  void scroll(unrestricted double x, unrestricted double y);
  void scroll(optional ScrollToOptions options);
  void scrollTo(unrestricted double x, unrestricted double y);
  void scrollTo(optional ScrollToOptions options);
  void scrollBy(unrestricted double x, unrestricted double y);
  void scrollBy(optional ScrollToOptions options);
  // mozScrollSnap is used by chrome to perform scroll snapping after the
  // user performs actions that may affect scroll position
  // mozScrollSnap is deprecated, to be replaced by a web accessible API, such
  // as an extension to the ScrollOptions dictionary.  See bug 1137937.
  [ChromeOnly] void mozScrollSnap();
  // The four properties below are double per spec at the moment, but whether
  // that will continue is unclear.
  [Replaceable, Throws] readonly attribute double scrollX;
  [Replaceable, Throws] readonly attribute double pageXOffset;
  [Replaceable, Throws] readonly attribute double scrollY;
  [Replaceable, Throws] readonly attribute double pageYOffset;

  // client
  // These are writable because we allow chrome to write them.  And they need
  // to use 'any' as the type, because non-chrome writing them needs to act
  // like a [Replaceable] attribute would, which needs the original JS value.
  //[Replaceable, Throws] readonly attribute double screenX;
  //[Replaceable, Throws] readonly attribute double screenY;
  //[Replaceable, Throws] readonly attribute double outerWidth;
  //[Replaceable, Throws] readonly attribute double outerHeight;
  [Throws, NeedsCallerType] attribute any screenX;
  [Throws, NeedsCallerType] attribute any screenY;
  [Throws, NeedsCallerType] attribute any outerWidth;
  [Throws, NeedsCallerType] attribute any outerHeight;
};

// https://dvcs.w3.org/hg/webperf/raw-file/tip/specs/RequestAnimationFrame/Overview.html
partial interface Window {
  [Throws] long requestAnimationFrame(FrameRequestCallback callback);
  [Throws] void cancelAnimationFrame(long handle);
};
callback FrameRequestCallback = void (DOMHighResTimeStamp time);

// https://dvcs.w3.org/hg/webperf/raw-file/tip/specs/NavigationTiming/Overview.html
partial interface Window {
  [Replaceable, Pure, StoreInSlot] readonly attribute Performance? performance;
};

// https://dvcs.w3.org/hg/webcrypto-api/raw-file/tip/spec/Overview.html
Window implements GlobalCrypto;

// https://fidoalliance.org/specifications/download/
Window implements GlobalU2F;

//#ifdef MOZ_WEBSPEECH
// http://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html
[NoInterfaceObject]
interface SpeechSynthesisGetter {
  [Throws, Pref="media.webspeech.synth.enabled"] readonly attribute SpeechSynthesis speechSynthesis;
};

Window implements SpeechSynthesisGetter;
//#endif

Window implements TouchEventHandlers;

Window implements OnErrorEventHandlerForWindow;

//#if defined(MOZ_WIDGET_ANDROID)
// https://compat.spec.whatwg.org/#windoworientation-interface
partial interface Window {
  [NeedsCallerType]
  readonly attribute short orientation;
           attribute EventHandler onorientationchange;
};
//#endif

callback PromiseDocumentFlushedCallback = any ();

partial interface Window {
  [Pref="dom.vr.enabled"]
  attribute EventHandler onvrdisplayconnect;
  [Pref="dom.vr.enabled"]
  attribute EventHandler onvrdisplaydisconnect;
  [Pref="dom.vr.enabled"]
  attribute EventHandler onvrdisplayactivate;
  [Pref="dom.vr.enabled"]
  attribute EventHandler onvrdisplaydeactivate;
  [Pref="dom.vr.enabled"]
  attribute EventHandler onvrdisplaypresentchange;
};

// https://drafts.css-houdini.org/css-paint-api-1/#dom-window-paintworklet
partial interface Window {
    [Pref="dom.paintWorklet.enabled", Throws]
    readonly attribute Worklet paintWorklet;
};

Window implements WindowOrWorkerGlobalScope;

partial interface Window {
  [Throws, Func="nsGlobalWindowInner::IsRequestIdleCallbackEnabled"]
  unsigned long requestIdleCallback(IdleRequestCallback callback,
                                    optional IdleRequestOptions options);
  [Func="nsGlobalWindowInner::IsRequestIdleCallbackEnabled"]
  void          cancelIdleCallback(unsigned long handle);
};

dictionary IdleRequestOptions {
  unsigned long timeout;
};

callback IdleRequestCallback = void (IdleDeadline deadline);

Window implements WebGPUProvider;
