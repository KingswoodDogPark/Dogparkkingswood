import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const KingswoodApp());
const forest=Color(0xff23462c), cream=Color(0xffeee4d2), sage=Color(0xffcbd9b7);
const site='https://5eictj-6u.myshopify.com';
class KingswoodApp extends StatelessWidget {
 const KingswoodApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner:false,title:'Kingswood Dog Park',theme:ThemeData(colorScheme:ColorScheme.fromSeed(seedColor:forest),scaffoldBackgroundColor:cream,useMaterial3:true),home:const Home());
}
class Home extends StatelessWidget {
 const Home({super.key});
 void book(BuildContext c,[int? field])=>Navigator.push(c,MaterialPageRoute(builder:(_)=>Portal(url:'$site/pages/booking${field==null?'':'?paddock=$field'}')));
 @override Widget build(BuildContext context)=>Scaffold(
 appBar:AppBar(backgroundColor:forest,foregroundColor:cream,title:const Text('KINGSWOOD  •  DOG PARK'),centerTitle:true),
 body:SafeArea(child:ListView(padding:EdgeInsets.zero,children:[
 Stack(children:[SizedBox(height:330,width:double.infinity,child:Image.network('https://cdn.shopify.com/s/files/1/1027/5451/7319/files/kingswood-cockapoo-hero.png?v=1795518377',fit:BoxFit.cover,errorBuilder:(_,__,___)=>Container(color:forest))),Positioned.fill(child:DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,forest.withOpacity(.95)])))),Positioned(left:24,right:24,bottom:24,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Freedom to run.\nSpace to explore.',style:TextStyle(fontFamily:'serif',fontSize:34,fontWeight:FontWeight.bold,color:cream,height:1.1)),const SizedBox(height:10),const Text('Private countryside paddocks • Albrighton',style:TextStyle(color:cream)),const SizedBox(height:16),SizedBox(width:double.infinity,child:FilledButton(style:FilledButton.styleFrom(backgroundColor:cream,foregroundColor:forest,padding:const EdgeInsets.all(16)),onPressed:()=>book(context),child:const Text('BOOK NOW  →')))]))]),
 const Padding(padding:EdgeInsets.all(20),child:Text('Choose your paddock',style:TextStyle(fontSize:26,fontFamily:'serif',fontWeight:FontWeight.bold,color:forest))),
 for(int i=0;i<4;i++) Padding(padding:const EdgeInsets.fromLTRB(16,0,16,10),child:Card(color:const Color(0xfffaf7ef),child:ListTile(contentPadding:const EdgeInsets.all(12),leading:const CircleAvatar(backgroundColor:sage,child:Icon(Icons.pets,color:forest)),title:Text('${i<2?'Small':'Large'} Paddock ${i%2+1}',style:const TextStyle(fontWeight:FontWeight.bold,color:forest)),subtitle:Text('£${i<2?8:10} • Up to 3 dogs included'),trailing:const Icon(Icons.chevron_right,color:forest),onTap:()=>book(context,i)))),
 const Padding(padding:EdgeInsets.all(24),child:Text('Private hire • Enclosed paddocks • Parking\nBooking demonstration only. No payment or reservation is made.',textAlign:TextAlign.center,style:TextStyle(color:forest))),
 ])),bottomNavigationBar:SafeArea(child:Padding(padding:const EdgeInsets.all(12),child:FilledButton.icon(style:FilledButton.styleFrom(backgroundColor:forest,foregroundColor:cream,padding:const EdgeInsets.all(16)),onPressed:()=>book(context),icon:const Icon(Icons.calendar_month),label:const Text('Book your adventure'))))));
}
class Portal extends StatefulWidget{
 final String url;const Portal({super.key,required this.url});
 @override State<Portal> createState()=>_PortalState();
}
class _PortalState extends State<Portal>{
 late final WebViewController controller;bool loading=true;bool failed=false;
 @override void initState(){super.initState();controller=WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..setNavigationDelegate(NavigationDelegate(onPageStarted:(_){if(mounted)setState((){loading=true;failed=false;});},onPageFinished:(_){if(mounted)setState(()=>loading=false);},onWebResourceError:(e){if(e.isForMainFrame==true&&mounted)setState((){failed=true;loading=false;});},onNavigationRequest:(r){final u=Uri.tryParse(r.url);return u?.scheme=='https'&&u?.host=='5eictj-6u.myshopify.com'?NavigationDecision.navigate:NavigationDecision.prevent;}))..loadRequest(Uri.parse(widget.url));}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(backgroundColor:forest,foregroundColor:cream,title:const Text('Book your paddock'),actions:[IconButton(onPressed:()=>controller.reload(),icon:const Icon(Icons.refresh),tooltip:'Refresh')]),body:SafeArea(child:Column(children:[const ColoredBox(color:sage,child:Padding(padding:EdgeInsets.all(10),child:Center(child:Text('Demo bookings only • No payment',style:TextStyle(color:forest))))),if(loading)const LinearProgressIndicator(),Expanded(child:failed?Center(child:FilledButton(onPressed:()=>controller.loadRequest(Uri.parse(widget.url)),child:const Text('Retry connection'))):WebViewWidget(controller:controller))])));
}
