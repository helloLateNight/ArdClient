Haven Resource 1< src 	  Pig.java /* Preprocessed source code */
/* $use: ui/croster */

package haven.res.gfx.hud.rosters.pig;

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class Pig extends Entry {
    public int meat, milk;
    public int meatq, milkq, hideq;
    public int seedq;
    public int prc;
    public boolean hog, piglet, dead, pregnant, lactate, owned, mine;

    public Pig(long id, String name) {
	super(SIZE, id, name);
    }

    public void draw(GOut g) {
	drawbg(g);
	int i = 0;
	drawcol(g, PigRoster.cols.get(i), 0, this, namerend, i++);
	drawcol(g, PigRoster.cols.get(i), 0.5, hog,      sex, i++);
	drawcol(g, PigRoster.cols.get(i), 0.5, piglet,   growth, i++);
	drawcol(g, PigRoster.cols.get(i), 0.5, dead,     deadrend, i++);
	drawcol(g, PigRoster.cols.get(i), 0.5, pregnant, pregrend, i++);
	drawcol(g, PigRoster.cols.get(i), 0.5, lactate,  lactrend, i++);
	drawcol(g, PigRoster.cols.get(i), 0.5, (owned ? 1 : 0) | (mine ? 2 : 0), ownrend, i++);
	drawcol(g, PigRoster.cols.get(i), 1, q, quality, i++);
	drawcol(g, PigRoster.cols.get(i), 1, prc, null, i++);
	drawcol(g, PigRoster.cols.get(i), 1, meat, null, i++);
	drawcol(g, PigRoster.cols.get(i), 1, milk, null, i++);
	drawcol(g, PigRoster.cols.get(i), 1, meatq, percent, i++);
	drawcol(g, PigRoster.cols.get(i), 1, milkq, percent, i++);
	drawcol(g, PigRoster.cols.get(i), 1, hideq, percent, i++);
	drawcol(g, PigRoster.cols.get(i), 1, seedq, null, i++);
	super.draw(g);
    }

    public boolean mousedown(Coord c, int button) {
	if(PigRoster.cols.get(1).hasx(c.x)) {
	    markall(Pig.class, o -> (o.hog == this.hog));
	    return(true);
	}
	if(PigRoster.cols.get(2).hasx(c.x)) {
	    markall(Pig.class, o -> (o.piglet == this.piglet));
	    return(true);
	}
	if(PigRoster.cols.get(3).hasx(c.x)) {
	    markall(Pig.class, o -> (o.dead == this.dead));
	    return(true);
	}
	if(PigRoster.cols.get(4).hasx(c.x)) {
	    markall(Pig.class, o -> (o.pregnant == this.pregnant));
	    return(true);
	}
	if(PigRoster.cols.get(5).hasx(c.x)) {
	    markall(Pig.class, o -> (o.lactate == this.lactate));
	    return(true);
	}
	if(PigRoster.cols.get(6).hasx(c.x)) {
	    markall(Pig.class, o -> ((o.owned == this.owned) && (o.mine == this.mine)));
	    return(true);
	}
	return(super.mousedown(c, button));
    }
}

/* >wdg: PigRoster */
src '  PigRoster.java /* Preprocessed source code */
/* $use: ui/croster */

package haven.res.gfx.hud.rosters.pig;

import haven.*;
import haven.res.ui.croster.*;
import java.util.*;

public class PigRoster extends CattleRoster<Pig> {
    public static List<Column> cols = initcols(
	new Column<Entry>("Name", Comparator.comparing((Entry e) -> e.name), 200),

	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/sex", 2),      Comparator.comparing((Pig e) -> e.hog).reversed(), 20).runon(),
	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/growth", 2),   Comparator.comparing((Pig e) -> e.piglet).reversed(), 20).runon(),
	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/deadp", 3),    Comparator.comparing((Pig e) -> e.dead).reversed(), 20).runon(),
	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/pregnant", 2), Comparator.comparing((Pig e) -> e.pregnant).reversed(), 20).runon(),
	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/lactate", 1),  Comparator.comparing((Pig e) -> e.lactate).reversed(), 20).runon(),
	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/owned", 1),    Comparator.comparing((Pig e) -> ((e.owned ? 1 : 0) | (e.mine ? 2 : 0))).reversed(), 20),

	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/quality", 2), Comparator.comparing((Pig e) -> e.q).reversed()),

	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/trufflesnout", 1), Comparator.comparing((Pig e) -> e.prc).reversed()),

	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/meatquantity", 1), Comparator.comparing((Pig e) -> e.meat).reversed()),
	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/milkquantity", 1), Comparator.comparing((Pig e) -> e.milk).reversed()),

	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/meatquality", 1), Comparator.comparing((Pig e) -> e.meatq).reversed()),
	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/milkquality", 1), Comparator.comparing((Pig e) -> e.milkq).reversed()),
	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/hidequality", 1), Comparator.comparing((Pig e) -> e.hideq).reversed()),

	new Column<Pig>(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/breedingquality", 1), Comparator.comparing((Pig e) -> e.seedq).reversed())
    );
    protected List<Column> cols() {return(cols);}

    public static CattleRoster mkwidget(UI ui, Object... args) {
	return(new PigRoster());
    }

    public Pig parse(Object... args) {
	int n = 0;
	long id = (Long)args[n++];
	String name = (String)args[n++];
	Pig ret = new Pig(id, name);
	ret.grp = (Integer)args[n++];
	int fl = (Integer)args[n++];
	ret.hog = (fl & 1) != 0;
	ret.piglet = (fl & 2) != 0;
	ret.dead = (fl & 4) != 0;
	ret.pregnant = (fl & 8) != 0;
	ret.lactate = (fl & 16) != 0;
	ret.owned = (fl & 32) != 0;
	ret.mine = (fl & 64) != 0;
	ret.q = ((Number)args[n++]).doubleValue();
	ret.meat = (Integer)args[n++];
	ret.milk = (Integer)args[n++];
	ret.meatq = (Integer)args[n++];
	ret.milkq = (Integer)args[n++];
	ret.hideq = (Integer)args[n++];
	ret.seedq = (Integer)args[n++];
	ret.prc = (Integer)args[n++];
	return(ret);
    }

    public TypeButton button() {
	return(typebtn(Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/btn-pig", 2),
		       Resource.classres(PigRoster.class).pool.load("gfx/hud/rosters/btn-pig-d", 2)));
    }
}
code �  haven.res.gfx.hud.rosters.pig.Pig ����   4 �	 ( W
 1 X
 ( Y	 Z [ \ ] ^	 ( _
 ( `?�      	 ( a
 b c	 ( d	 ( e	 ( f	 ( g	 ( h	 ( i	 ( j	 ( k	 ( l	 ( m	 ( n
 o p	 ( q	 ( r
 s t	 ( u	 ( v	 ( w	 ( x	 ( y	 ( z	 ( {	 ( |	 ( }
 1 ~	  �
  � �   �
 ( �  �  �  �  �  �
 1 � � meat I milk meatq milkq hideq seedq prc hog Z piglet dead pregnant lactate owned mine <init> (JLjava/lang/String;)V Code LineNumberTable draw (Lhaven/GOut;)V StackMapTable � � ^ 	mousedown (Lhaven/Coord;I)Z lambda$mousedown$5 &(Lhaven/res/gfx/hud/rosters/pig/Pig;)Z lambda$mousedown$4 lambda$mousedown$3 lambda$mousedown$2 lambda$mousedown$1 lambda$mousedown$0 
SourceFile Pig.java � � B � � G � � � � � � haven/res/ui/croster/Column � � � � : ; � � � � � < ; � � = ; � � > ; � � ? ; � � @ ; A ; � � � � � � � � � � � � 9 3 2 3 4 3 5 3 � � 6 3 7 3 8 3 F G � � 3 � � !haven/res/gfx/hud/rosters/pig/Pig BootstrapMethods � � � O � � � � � � � � � L M haven/res/ui/croster/Entry 
haven/GOut SIZE Lhaven/Coord; #(Lhaven/Coord;JLjava/lang/String;)V drawbg 'haven/res/gfx/hud/rosters/pig/PigRoster cols Ljava/util/List; java/util/List get (I)Ljava/lang/Object; namerend Ljava/util/function/Function; drawcol ](Lhaven/GOut;Lhaven/res/ui/croster/Column;DLjava/lang/Object;Ljava/util/function/Function;I)V java/lang/Boolean valueOf (Z)Ljava/lang/Boolean; sex growth deadrend pregrend lactrend java/lang/Integer (I)Ljava/lang/Integer; ownrend q D java/lang/Double (D)Ljava/lang/Double; quality percent haven/Coord x hasx (I)Z
 � � (Ljava/lang/Object;)Z
 ( � test C(Lhaven/res/gfx/hud/rosters/pig/Pig;)Ljava/util/function/Predicate; markall 2(Ljava/lang/Class;Ljava/util/function/Predicate;)V
 ( �
 ( �
 ( �
 ( �
 ( � � � � T O S O R O Q O P O N O "java/lang/invoke/LambdaMetafactory metafactory � Lookup InnerClasses �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; � %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles 	pig.cjava ! ( 1     2 3    4 3    5 3    6 3    7 3    8 3    9 3    : ;    < ;    = ;    > ;    ? ;    @ ;    A ;   	  B C  D   &     
*� -� �    E   
     	   F G  D  �     *+� =*+� �  � *� �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � �� *+� �  �  	*� � � *� � � �� � �� *+� �  � *� � � �� *+� �  � *� � �� *+� �  � *� � �� *+� �  � *� � �� *+� �  � *�  � � !�� *+� �  � *� "� � !�� *+� �  � *� #� � !�� *+� �  � *� $� �� *+� %�    H   f � �  I J  I J K�    I J  I J K� 
  I J  I J K�    I J  I J K E   N         !  C  e  �  �  �  " @  ^ !| "� #� $� %� &� '  L M  D  N     � �  � +� &� '� *(*� )  � *�� �  � +� &� '� *(*� +  � *�� �  � +� &� '� *(*� ,  � *�� �  � +� &� '� *(*� -  � *�� �  � +� &� '� *(*� .  � *�� �  � +� &� '� *(*� /  � *�*+� 0�    H    $####$ E   N    *  + " , $ . : / F 0 H 2 ^ 3 j 4 l 6 � 7 � 8 � : � ; � < � > � ? � @ � B N O  D   ?     +� *� � +� *� � � �    H    @ E       ? P O  D   4     +� *� � � �    H    @ E       ; Q O  D   4     +� *� � � �    H    @ E       7 R O  D   4     +� *� � � �    H    @ E       3 S O  D   4     +� *� � � �    H    @ E       / T O  D   4     +� *� � � �    H    @ E       +  �   >  �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � U    � �   
  � � � code n  haven.res.gfx.hud.rosters.pig.PigRoster ����   4E
 O }	  ~ 
  } �
  � � �
  � �
 
 �	  �	  �	  �	  �	  �	  �	  �	  � �
  �	  �	  �	  �	  �	  �	  �	  �	  �
 � �	 � � �
 � � �
  �
  �
 
 �
 � �
 � �	 � � � �   � � �
 ) � �  � � �
 ) �
 ) � �  � �  � �  � �  � �  � �  �
 ) � �  � � 	 � � 
 � �  � �  � �  � �  �
  � � cols Ljava/util/List; 	Signature /Ljava/util/List<Lhaven/res/ui/croster/Column;>; <init> ()V Code LineNumberTable ()Ljava/util/List; 1()Ljava/util/List<Lhaven/res/ui/croster/Column;>; mkwidget B(Lhaven/UI;[Ljava/lang/Object;)Lhaven/res/ui/croster/CattleRoster; parse 8([Ljava/lang/Object;)Lhaven/res/gfx/hud/rosters/pig/Pig; StackMapTable  � � � button #()Lhaven/res/ui/croster/TypeButton; 1([Ljava/lang/Object;)Lhaven/res/ui/croster/Entry; lambda$static$14 8(Lhaven/res/gfx/hud/rosters/pig/Pig;)Ljava/lang/Integer; lambda$static$13 lambda$static$12 lambda$static$11 lambda$static$10 lambda$static$9 lambda$static$8 lambda$static$7 7(Lhaven/res/gfx/hud/rosters/pig/Pig;)Ljava/lang/Double; lambda$static$6 lambda$static$5 8(Lhaven/res/gfx/hud/rosters/pig/Pig;)Ljava/lang/Boolean; lambda$static$4 lambda$static$3 lambda$static$2 lambda$static$1 lambda$static$0 0(Lhaven/res/ui/croster/Entry;)Ljava/lang/String; <clinit> HLhaven/res/ui/croster/CattleRoster<Lhaven/res/gfx/hud/rosters/pig/Pig;>; 
SourceFile PigRoster.java T U P Q 'haven/res/gfx/hud/rosters/pig/PigRoster java/lang/Long � � java/lang/String !haven/res/gfx/hud/rosters/pig/Pig T � java/lang/Integer � � � � � � � � � � � � � � � � � � java/lang/Number � � � � � � � � � � � � � � � � � � � � � � � gfx/hud/rosters/btn-pig � � � gfx/hud/rosters/btn-pig-d  \ ]	
 haven/res/ui/croster/Column Name BootstrapMethods x T gfx/hud/rosters/sex r T gfx/hud/rosters/growth gfx/hud/rosters/deadp gfx/hud/rosters/pregnant gfx/hud/rosters/lactate gfx/hud/rosters/owned g gfx/hud/rosters/quality o T  gfx/hud/rosters/trufflesnout! gfx/hud/rosters/meatquantity" gfx/hud/rosters/milkquantity# gfx/hud/rosters/meatquality$ gfx/hud/rosters/milkquality% gfx/hud/rosters/hidequality& gfx/hud/rosters/breedingquality'() !haven/res/ui/croster/CattleRoster [Ljava/lang/Object; 	longValue ()J (JLjava/lang/String;)V intValue ()I grp I hog Z piglet dead pregnant lactate owned mine doubleValue ()D q D meat milk meatq milkq hideq seedq prc haven/Resource classres #(Ljava/lang/Class;)Lhaven/Resource; pool Pool InnerClasses Lhaven/Resource$Pool; haven/Resource$Pool load* Named +(Ljava/lang/String;I)Lhaven/Resource$Named; typebtn =(Lhaven/Indir;Lhaven/Indir;)Lhaven/res/ui/croster/TypeButton; valueOf (I)Ljava/lang/Integer; java/lang/Double (D)Ljava/lang/Double; java/lang/Boolean (Z)Ljava/lang/Boolean; haven/res/ui/croster/Entry name Ljava/lang/String;
+, &(Ljava/lang/Object;)Ljava/lang/Object;
 - apply ()Ljava/util/function/Function; java/util/Comparator 	comparing 5(Ljava/util/function/Function;)Ljava/util/Comparator; ,(Ljava/lang/String;Ljava/util/Comparator;I)V
 . reversed ()Ljava/util/Comparator; '(Lhaven/Indir;Ljava/util/Comparator;I)V runon ()Lhaven/res/ui/croster/Column;
 /
 0
 1
 2
 3
 4 &(Lhaven/Indir;Ljava/util/Comparator;)V
 5
 6
 7
 8
 9
 :
 ; initcols 0([Lhaven/res/ui/croster/Column;)Ljava/util/List; haven/Resource$Named<=@ w x v r u r t r s r q r p g n o m g l g k g j g i g h g f g "java/lang/invoke/LambdaMetafactory metafactoryB Lookup �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;C %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles 	pig.cjava !  O    	 P Q  R    S   T U  V        *� �    W       G  P X  V        � �    W       _ R    Y � Z [  V         � Y� �    W       b � \ ]  V  �    K=+�2� � B+�2� :� Y!� 	:+�2� 
� � +�2� 
� 6~� � � ~� � � ~� � � ~� � � ~� � �  ~� � � @~� � � +�2� � � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � +�2� 
� � �    ^   � � R  _ ` a b  b�    _ ` a b  bO b�    _ ` a b  bO b�    _ ` a b  bP b�    _ ` a b  bP b�    _ ` a b  bP b�    _ ` a b  bP b�    _ ` a b  b W   Z    f  g  h  i & j 7 k E l V m g n x o � p � q � r � s � t � u � v w x& y7 zH {  c d  V   @      � �  � !� � "� !� #�    W         �  A \ e  V        *+� $�    W       G
 f g  V         *� � %�    W       ]
 h g  V         *� � %�    W       [
 i g  V         *� � %�    W       Z
 j g  V         *� � %�    W       Y
 k g  V         *� � %�    W       W
 l g  V         *� � %�    W       V
 m g  V         *� � %�    W       T
 n o  V         *� � &�    W       R
 p g  V   N     *� � � *� � � �� %�    ^    @J�    b  W       P
 q r  V         *� � '�    W       O
 s r  V         *� � '�    W       N
 t r  V         *� � '�    W       M
 u r  V         *� � '�    W       L
 v r  V         *� � '�    W       K
 w x  V        *� (�    W       I  y U  V  �     M� )Y� )Y*� +  � , ȷ -SY� )Y� � .� !� /  � ,� 0 � 1� 2SY� )Y� � 3� !� 4  � ,� 0 � 1� 2SY� )Y� � 5� !� 6  � ,� 0 � 1� 2SY� )Y� � 7� !� 8  � ,� 0 � 1� 2SY� )Y� � 9� !� :  � ,� 0 � 1� 2SY� )Y� � ;� !� <  � ,� 0 � 1SY� )Y� � =� !� >  � ,� 0 � ?SY� )Y� � @� !� A  � ,� 0 � ?SY	� )Y� � B� !� C  � ,� 0 � ?SY
� )Y� � D� !� E  � ,� 0 � ?SY� )Y� � F� !� G  � ,� 0 � ?SY� )Y� � H� !� I  � ,� 0 � ?SY� )Y� � J� !� K  � ,� 0 � ?SY� )Y� � L� !� M  � ,� 0 � ?S� N� �    W   F    H  I $ K N L x M � N � O � P RE Tk V� W� Y� Z [) ]F H  �   �  �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � �  � � � {   D R    z �     � � � 	 � � �	>A? codeentry >   wdg haven.res.gfx.hud.rosters.pig.PigRoster   ui/croster H  