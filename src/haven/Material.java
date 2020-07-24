/*
 *  This file is part of the Haven & Hearth game client.
 *  Copyright (C) 2009 Fredrik Tolf <fredrik@dolda2000.com>, and
 *                     Björn Johannessen <johannessen.bjorn@gmail.com>
 *
 *  Redistribution and/or modification of this file is subject to the
 *  terms of the GNU Lesser General Public License, version 3, as
 *  published by the Free Software Foundation.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  Other parts of this source tree adhere to other copying
 *  rights. Please see the file `COPYING' in the root directory of the
 *  source tree for details.
 *
 *  A copy the GNU Lesser General Public License is distributed along
 *  with the source tree of which this file is a part in the file
 *  `doc/LPGL-3'. If it is missing for any reason, please see the Free
 *  Software Foundation's website at <http://www.fsf.org/>, or write
 *  to the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 *  Boston, MA 02111-1307 USA
 */

package haven;

import java.awt.Color;
import java.util.*;
import java.lang.annotation.*;
import java.lang.reflect.*;

import haven.render.*;

import javax.media.opengl.GL;
import javax.media.opengl.GL2;

import static haven.Utils.c2fa;

public class Material implements Pipe.Op {
	public final Pipe.Op states, dynstates;

	public static final Pipe.Op nofacecull = (p -> p.put(States.facecull, null));

	@ResName("nofacecull")
	public static class $nofacecull implements ResCons {
		public Pipe.Op cons(Resource res, Object... args) {
			return (nofacecull);
		}
	}

	public static final float[] defamb = {0.2f, 0.2f, 0.2f, 1.0f};
	public static final float[] defdif = {0.8f, 0.8f, 0.8f, 1.0f};
	public static final float[] defspc = {0.0f, 0.0f, 0.0f, 1.0f};
	public static final float[] defemi = {0.0f, 0.0f, 0.0f, 1.0f};

	public static final GLState.Slot<Colors> colors = new GLState.Slot<Colors>(GLState.Slot.Type.DRAW, Colors.class);

	@ResName("col")
	public static class Colors extends GLState {
		public float[] amb, dif, spc, emi;
		public float shine;

		public Colors() {
			amb = defamb;
			dif = defdif;
			spc = defspc;
			emi = defemi;
		}

		public Colors(float[] amb, float[] dif, float[] spc, float[] emi, float shine) {
			this.amb = amb;
			this.dif = dif;
			this.spc = spc;
			this.emi = emi;
			this.shine = shine;
		}

		private static float[] colmul(float[] c1, float[] c2) {
			return (new float[]{c1[0] * c2[0], c1[1] * c2[1], c1[2] * c2[2], c1[3] * c2[3]});
		}

		private static float[] colblend(float[] in, float[] bl) {
			float f1 = bl[3], f2 = 1.0f - f1;
			return (new float[]{(in[0] * f2) + (bl[0] * f1),
					(in[1] * f2) + (bl[1] * f1),
					(in[2] * f2) + (bl[2] * f1),
					in[3]});
		}

		public Colors(Color amb, Color dif, Color spc, Color emi, float shine) {
			this(c2fa(amb), c2fa(dif), c2fa(spc), c2fa(emi), shine);
		}

		public Colors(Color amb, Color dif, Color spc, Color emi) {
			this(amb, dif, spc, emi, 0);
		}

		public Colors(Color col) {
			this(new Color((int) (col.getRed() * defamb[0]), (int) (col.getGreen() * defamb[1]), (int) (col.getBlue() * defamb[2]), col.getAlpha()),
					new Color((int) (col.getRed() * defdif[0]), (int) (col.getGreen() * defdif[1]), (int) (col.getBlue() * defdif[2]), col.getAlpha()),
					new Color(0, 0, 0, 0),
					new Color(0, 0, 0, 0),
					0);
		}

		public Colors(Resource res, Object... args) {
			this((Color) args[0], (Color) args[1], (Color) args[2], (Color) args[3], (Float) args[4]);
		}

		public void apply(GOut g) {
			BGL gl = g.gl;
			gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL2.GL_AMBIENT, amb, 0);
			gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL2.GL_DIFFUSE, dif, 0);
			gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL2.GL_SPECULAR, spc, 0);
			gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL2.GL_EMISSION, emi, 0);
			gl.glMaterialf(GL.GL_FRONT_AND_BACK, GL2.GL_SHININESS, shine);
		}

		public void unapply(GOut g) {
			BGL gl = g.gl;
			gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL2.GL_AMBIENT, defamb, 0);
			gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL2.GL_DIFFUSE, defdif, 0);
			gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL2.GL_SPECULAR, defspc, 0);
			gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL2.GL_EMISSION, defemi, 0);
			gl.glMaterialf(GL.GL_FRONT_AND_BACK, GL2.GL_SHININESS, 0.0f);
		}

		public int capplyfrom(GLState from) {
			if (from instanceof Colors)
				return (5);
			return (-1);
		}

		public void applyfrom(GOut g, GLState from) {
			if (from instanceof Colors)
				apply(g);
		}

		public void prep(Buffer buf) {
			Colors p = buf.get(colors);
			if (p != null)
				buf.put(colors, p.combine(this));
			else
				buf.put(colors, this);
		}

		public Colors combine(Colors other) {
			return (new Colors(colblend(other.amb, this.amb),
					colblend(other.dif, this.dif),
					colblend(other.spc, this.spc),
					colblend(other.emi, this.emi),
					other.shine));
		}

		public String toString() {
			return (String.format("(%.1f, %.1f, %.1f), (%.1f, %.1f, %.1f), (%.1f, %.1f, %.1f @ %.1f)",
					amb[0], amb[1], amb[2], dif[0], dif[1], dif[2], spc[0], spc[1], spc[2], shine));
		}
	}

	@ResName("maskcol")
	public static class $maskcol implements ResCons {
		final Pipe.Op mask = p -> p.put(FragColor.slot, null);

		public Pipe.Op cons(Resource res, Object... args) {
			return (mask);
		}
	}

	@ResName("maskdepth")
	public static class $maskdepth implements ResCons {
		public Pipe.Op cons(Resource res, Object... args) {
			return (States.maskdepth);
		}
	}

	@ResName("vcol")
	public static class $vcol implements ResCons {
		public Pipe.Op cons(Resource res, Object... args) {
			return (new BaseColor((Color) args[0]));
		}
	}

	@ResName("blend")
	public static class $blend implements ResCons {
		private static States.Blending.Function fn(Resource res, char desc) {
			switch (desc) {
				case '+':
					return States.Blending.Function.ADD;
				case '-':
					return States.Blending.Function.SUB;
				case '_':
					return States.Blending.Function.RSUB;
				case '>':
					return States.Blending.Function.MAX;
				case '<':
					return States.Blending.Function.MIN;
				default:
					throw (new Resource.LoadException("Unknown blend function: " + desc, res));
			}
		}

		private static States.Blending.Factor fac(Resource res, char desc) {
			switch (desc) {
				case '0':
					return States.Blending.Factor.ZERO;
				case '1':
					return States.Blending.Factor.ONE;
				case 'a':
					return States.Blending.Factor.SRC_ALPHA;
				case 'A':
					return States.Blending.Factor.INV_SRC_ALPHA;
				case 'c':
					return States.Blending.Factor.SRC_COLOR;
				case 'C':
					return States.Blending.Factor.INV_SRC_COLOR;
				default:
					throw (new Resource.LoadException("Unknown blend factor: " + desc, res));
			}
		}

		public Pipe.Op cons(Resource res, Object... args) {
			States.Blending.Function cfn, afn;
			States.Blending.Factor csrc, cdst, asrc, adst;
			String desc = (String) args[0];
			if (desc.length() < 3)
				throw (new Resource.LoadException("Bad blend description: " + desc, res));
			cfn = fn(res, desc.charAt(0));
			csrc = fac(res, desc.charAt(1));
			cdst = fac(res, desc.charAt(2));
			if (desc.length() < 6) {
				afn = cfn;
				asrc = csrc;
				adst = cdst;
			} else {
				afn = fn(res, desc.charAt(3));
				asrc = fac(res, desc.charAt(4));
				adst = fac(res, desc.charAt(5));
			}
			return (new States.Blending(cfn, csrc, cdst, afn, asrc, adst));
		}
	}

	@ResName("order")
	public static class $order implements ResCons {
		public Pipe.Op cons(Resource res, Object... args) {
			String nm = (String) args[0];
			if (nm.equals("first")) {
				return (Rendered.first);
			} else if (nm.equals("last")) {
				return (Rendered.last);
			} else if (nm.equals("pfx")) {
				return (Rendered.postpfx);
			} else if (nm.equals("eye")) {
				return (Rendered.eyesort);
			} else if (nm.equals("earlyeye")) {
				return (Rendered.eeyesort);
			} else if (nm.equals("premap")) {
				return (MapMesh.premap);
			} else if (nm.equals("postmap")) {
				return (MapMesh.postmap);
			} else {
				throw (new Resource.LoadException("Unknown draw order: " + nm, res));
			}
		}
	}

	public Material(Pipe.Op[] states, Pipe.Op[] dynstates) {
		this.states = Pipe.Op.compose(states);
		this.dynstates = Pipe.Op.compose(dynstates);
	}

	public Material(Pipe.Op... states) {
		this(states, new Pipe.Op[0]);
	}

	public String toString() {
		return (Arrays.asList(states, dynstates).toString());
	}

	public void apply(Pipe p) {
		states.apply(p);
		dynstates.apply(p);
	}

	/* This is actually an interesting inflection point. Right now,
	 * Material overriding apply() seems more like an ugly hack to
	 * support dynamic vs. static states. However, allowing materials
	 * to more truly own their own wrapping slots opens up such
	 * possibilities as them adding their children multiple times for
	 * more complex rendering techniques, which might be quite useful,
	 * and is well worth considering converting more fully to. In that
	 * case, materials probably shouldn't even be pipe-ops at all, but
	 * rather having apply() as their main and only interface. */
	public Wrapping apply(RenderTree.Node r) {
		if (dynstates != Pipe.Op.nil) {
			if (states == Pipe.Op.nil)
				return (dynstates.apply(r, false));
			r = dynstates.apply(r, false);
		}
		return (states.apply(r, true));
	}

	public interface Owner extends OwnerContext {
	}

	@Resource.PublishedCode(name = "mat")
	public static interface Factory {
		public default Material create(Owner owner, Resource res, Message sdt) {
			try {
				return (create(owner.context(Glob.class), res, sdt));
			} catch (OwnerContext.NoContext e) {
				return (create((Glob) null, res, sdt));
			}
		}

		@Deprecated
		public default Material create(Glob glob, Resource res, Message sdt) {
			throw (new AbstractMethodError("material factory missing either create method"));
		}
	}

	public static Material fromres(Owner owner, Resource res, Message sdt) {
		Factory f = res.getcode(Factory.class, false);
		if (f != null) {
			return (f.create(owner, res, sdt));
		}
		Res mat = res.layer(Res.class);
		if (mat == null)
			return (null);
		return (mat.get());
	}

	private static class LegacyOwner implements Owner {
		final Glob glob;

		LegacyOwner(Glob glob) {
			this.glob = glob;
		}

		private static final ClassResolver<LegacyOwner> ctxr = new ClassResolver<LegacyOwner>()
				.add(Glob.class, o -> o.glob)
				.add(Session.class, o -> o.glob.sess);

		public <T> T context(Class<T> cl) {
			return (ctxr.context(cl, this));
		}
	}

	@Deprecated
	public static Material fromres(Glob glob, Resource res, Message sdt) {
		return (fromres(new LegacyOwner(glob), res, sdt));
	}

	public static class Res extends Resource.Layer implements Resource.IDLayer<Integer> {
		public final int id;
		private transient List<Pipe.Op> states = new LinkedList<>(), dynstates = new LinkedList<>();
		private transient List<Resolver> left = new LinkedList<>();
		private transient Material m;

		public interface Resolver {
			public void resolve(Collection<Pipe.Op> buf, Collection<Pipe.Op> dynbuf);
		}

		public Res(Resource res, int id) {
			res.super();
			this.id = id;
		}

		public Material get() {
			synchronized (this) {
				if (m == null) {
					for (Iterator<Resolver> i = left.iterator(); i.hasNext(); ) {
						Resolver r = i.next();
						r.resolve(states, dynstates);
						i.remove();
					}
					m = new Material(states.toArray(new Pipe.Op[0]), dynstates.toArray(new Pipe.Op[0])) {
						public String toString() {
							return (super.toString() + "@" + getres().name);
						}
					};
				}
				return (m);
			}
		}

		public void init() {
		}

		public Integer layerid() {
			return (id);
		}
	}

	@ResName("mlink")
	public static class $mlink implements ResCons2 {
		public Res.Resolver cons(final Resource res, Object... args) {
			final Indir<Resource> lres;
			final int id;
			if (args[0] instanceof String) {
				lres = res.pool.load((String) args[0], (Integer) args[1]);
				id = (args.length > 2) ? (Integer) args[2] : -1;
			} else {
				lres = res.indir();
				id = (Integer) args[0];
			}
			return (new Res.Resolver() {
				public void resolve(Collection<Pipe.Op> buf, Collection<Pipe.Op> dynbuf) {
					if (id >= 0) {
						Res mat = lres.get().layer(Res.class, id);
						if (mat == null)
							throw (new Resource.LoadException("No such material in " + lres.get() + ": " + id, res));
						Material m = mat.get();
						if (m.states != Pipe.Op.nil)
							buf.add(m.states);
						if (m.dynstates != Pipe.Op.nil)
							dynbuf.add(m.dynstates);
					} else {
						Material mat = fromres((Owner) null, lres.get(), Message.nil);
						if (mat == null)
							throw (new Resource.LoadException("No material in " + lres.get(), res));
						if (mat.states != Pipe.Op.nil)
							buf.add(mat.states);
						if (mat.dynstates != Pipe.Op.nil)
							dynbuf.add(mat.dynstates);
					}
				}
			});
		}
	}

	@dolda.jglob.Discoverable
	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	public @interface ResName {
		public String value();
	}

	public interface ResCons {
		public Pipe.Op cons(Resource res, Object... args);
	}

	public interface ResCons2 {
		public Res.Resolver cons(Resource res, Object... args);
	}

	private static final Map<String, ResCons2> rnames = new TreeMap<String, ResCons2>();

	static {
		for (Class<?> cl : dolda.jglob.Loader.get(ResName.class).classes()) {
			String nm = cl.getAnnotation(ResName.class).value();
			if (ResCons.class.isAssignableFrom(cl)) {
				final ResCons scons;
				try {
					scons = cl.asSubclass(ResCons.class).newInstance();
				} catch (InstantiationException e) {
					throw (new Error(e));
				} catch (IllegalAccessException e) {
					throw (new Error(e));
				}
				rnames.put(nm, new ResCons2() {
					public Res.Resolver cons(Resource res, Object... args) {
						final Pipe.Op ret = scons.cons(res, args);
						return (new Res.Resolver() {
							public void resolve(Collection<Pipe.Op> buf, Collection<Pipe.Op> dynbuf) {
								if (ret != null)
									buf.add(ret);
							}
						});
					}
				});
			} else if (ResCons2.class.isAssignableFrom(cl)) {
				try {
					rnames.put(nm, cl.asSubclass(ResCons2.class).newInstance());
				} catch (InstantiationException e) {
					throw (new Error(e));
				} catch (IllegalAccessException e) {
					throw (new Error(e));
				}
			} else if (Pipe.Op.class.isAssignableFrom(cl)) {
				Constructor<? extends Pipe.Op> cons;
				try {
					cons = cl.asSubclass(Pipe.Op.class).getConstructor(Resource.class, Object[].class);
				} catch (NoSuchMethodException e) {
					throw (new Error("No proper constructor for res-consable GL state " + cl.getName(), e));
				}
				rnames.put(nm, new ResCons2() {
					public Res.Resolver cons(Resource res, Object... args) {
						return (new Res.Resolver() {
							public void resolve(Collection<Pipe.Op> buf, Collection<Pipe.Op> dynbuf) {
								buf.add(Utils.construct(cons, res, args));
							}
						});
					}
				});
			} else {
				throw (new Error("Illegal material constructor class: " + cl));
			}
		}
	}

	@Resource.LayerName("mat2")
	public static class NewMat implements Resource.LayerFactory<Res> {
		public Res cons(Resource res, Message buf) {
			int id = buf.uint16();
			Res ret = new Res(res, id);
			while (!buf.eom()) {
				String nm = buf.string();
				Object[] args = buf.list();
				ResCons2 cons = rnames.get(nm);
		/* XXXRENDER
		if(cons == null)
		    throw(new Resource.LoadException("Unknown material part name: " + nm, res));
		*/
				if (cons != null)
					ret.left.add(cons.cons(res, args));
				else
					System.err.printf("Uknown material part name: %s\n", nm);
			}
			return (ret);
		}
	}
}
