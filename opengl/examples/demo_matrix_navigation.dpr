{
  Copyright 2006 Michalis Kamburelis.

  This file is part of "Kambi's OpenGL Pascal units".

  "Kambi's OpenGL Pascal units" is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  "Kambi's OpenGL Pascal units" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with "Kambi's OpenGL Pascal units"; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

{ This is a simple demo of TMatrixExaminer class.
  As you can see, in the simplest case you just
  - use GLW_Navigated unit
  - init Glw.Navigator at the beginning of your program
  - call glLoadMatrix(glw.Navigator.Matrix) at the beginning
    of your draw

  And user instantly gets the ability to move and rotate the object
  by arrow keys etc. (see view3dscene keys is "Examine" mode:
  [http://www.camelot.homedns.org/~michalis/view3dscene.php]).
}

program demo_matrix_navigation;

uses VectorMath, Boxes3d, OpenGLh, GLWindow,
  GLW_Navigated, KambiClassUtils, KambiUtils, SysUtils, Classes,
  KambiGLUtils, MatrixNavigation, KambiFilesUtils;

procedure Draw(glwin: TGLWindow);
var
  q: PGLUQuadric;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glLoadMatrix(glw.Navigator.Matrix);

  q := NewGLUQuadric(GL_FALSE, GLU_SMOOTH, GLU_OUTSIDE, GLU_FILL);
  try
    gluSphere(q, 1, 10, 10);
  finally gluDeleteQuadric(q) end;
end;

procedure Init(glwin: TGLWindow);
begin
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  glEnable(GL_DEPTH_TEST);
end;

procedure Resize(glwin: TGLWindow);
begin
  glViewport(0, 0, glwin.Width, glwin.Height);
  ProjectionGLPerspective(45.0, glwin.Width/glwin.Height, 0.1, 100);
end;

begin
  { init Glw.Navigator }
  Glw.Navigator := TMatrixExaminer.Create(@Glw.PostRedisplayOnMatrixChanged);
  Glw.NavExaminer.Init(Box3d(
    Vector3Single(-1, -1, -1),
    Vector3Single( 1,  1,  1)));

  Glw.OnInit := @Init;
  Glw.OnResize := @Resize;
  Glw.InitLoop(ProgramName, @Draw);
end.
